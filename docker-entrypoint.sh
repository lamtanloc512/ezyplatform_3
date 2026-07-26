#!/bin/bash
# Starts the requested service: admin | web | socket | all (all three in one
# container, for a single-service Railway deployment).
#
# EzyPlatform treats its whole install directory as mutable, self-updating
# state (update.sh overwrites admin/lib, web/lib, socket/lib, lib/, resources
# etc.; the admin UI writes plugin jars under admin/plugins, web/plugins).
# So on Railway, RAILWAY_VOLUME_MOUNT_PATH's volume holds the *entire* app
# (like a VPS install disk), seeded from the image once on first boot only.
# On every later boot the volume's copy is authoritative for that runtime
# state and is NOT resynced from the image - platform/plugin updates must be
# applied against the live volume (via EzyPlatform's own updater), not by
# redeploying.
#
# Plain deployment config files are the exception: those aren't runtime
# state, so CONFIG_FILES below is resynced from the image on every boot,
# meaning git-tracked config changes DO take effect on redeploy as normal.
#
# Without RAILWAY_VOLUME_MOUNT_PATH (plain docker-compose), we run in place
# from /ezyplatform and expect the narrow per-directory bind mounts in
# docker-compose.yml, seeded here from the .seed-* copies baked at build time.
set -e

seed() {
    src="$1"; dst="$2"
    if [ -d "$dst" ] && [ -z "$(ls -A "$dst" 2>/dev/null)" ]; then
        cp -a "$src/." "$dst/" 2>/dev/null || true
    fi
}

# Deployment config, not runtime state - always resynced from the image so
# git changes apply on redeploy without wiping plugins/self-updated jars.
CONFIG_FILES="web/settings/config.properties admin/settings/config.properties socket/settings/config.properties"

DATA_DIR="${RAILWAY_VOLUME_MOUNT_PATH:-}"

if [ -n "$DATA_DIR" ]; then
    APP_DIR="$DATA_DIR/app"
    mkdir -p "$APP_DIR"
    if [ -z "$(ls -A "$APP_DIR" 2>/dev/null)" ]; then
        cp -a /ezyplatform/. "$APP_DIR/"
    fi
    cd "$APP_DIR"
    mkdir -p logs upload admin/plugins web/plugins
    for f in $CONFIG_FILES; do
        [ -f "/ezyplatform/$f" ] && cp -a "/ezyplatform/$f" "$f"
    done
else
    cd /ezyplatform
    seed .seed-settings settings
    seed .seed-web-themes web/themes
    seed .seed-socket-plugins socket/plugins
    seed .seed-admin-plugins admin/plugins
    seed .seed-web-plugins web/plugins
    mkdir -p logs upload
fi

# datasource.* is regenerated from env vars on every boot (not just seeded
# once) so it always reflects the current DB_* variables, e.g. after
# pointing at a different Railway MySQL instance. Everything else in
# settings/ (platform-key.txt, platform.properties) is left as seeded.
cat > settings/setup.properties <<EOF
datasource.jdbc_url=jdbc:mysql://${DB_HOST:-mysql}:${DB_PORT:-3306}/${DB_NAME:-ezyplatform}
datasource.driver_class_name=com.mysql.cj.jdbc.Driver
datasource.username=${DB_USER:-root}
datasource.password=${DB_PASSWORD:-12345678}
tables.create_manually=false
EOF

plugin_cp() {
    base="$1"; CP_EXTRA=""
    for d in "$base"/plugins/*/lib; do
        [ -d "$d" ] && CP_EXTRA="$CP_EXTRA:$d/*"
    done
    for d in "$base"/plugins/*/resources; do
        [ -d "$d" ] && CP_EXTRA="$CP_EXTRA:$d"
    done
    echo "$CP_EXTRA"
}

run_admin() {
    CP="lib/*:external/lib/*:external/resources:settings:admin/lib/*:admin/settings:admin/resources"
    CP="$CP$(plugin_cp admin)"
    # admin/stop-service.sh (and the admin UI's own Restart button) look for
    # our PID here - exec keeps this process's PID, so BASHPID (not $$, which
    # bash doesn't update inside a backgrounded subshell) is what java becomes.
    mkdir -p admin/.runtime
    echo $BASHPID > admin/.runtime/admin_server_instance.pid
    exec java $JAVA_OPTS -cp "$CP" org.youngmonkeys.ezyplatform.admin.AdminStartup
}

run_web() {
    CP="lib/*:external/lib/*:external/resources:settings:web/lib/*:web/settings:web/public:web/resources"
    CP="$CP$(plugin_cp web)"
    for d in web/themes/*/lib; do
        [ -d "$d" ] && CP="$CP:$d/*"
    done
    for d in web/themes/*/resources; do
        [ -d "$d" ] && CP="$CP:$d"
    done
    exec java $JAVA_OPTS -cp "$CP" org.youngmonkeys.ezyplatform.web.WebStartup
}

run_socket() {
    CP="lib/*:external/lib/*:external/resources:settings:socket/lib/*:socket/settings"
    CP="$CP$(plugin_cp socket)"
    exec java $JAVA_OPTS -cp "$CP" org.youngmonkeys.ezyplatform.socket.SocketStartup socket/settings/socket.properties
}

# Plugin/theme installs from the admin UI need a full process restart to
# take effect (Java's -cp classpath is fixed at JVM boot, plugin_cp() only
# rescans on a fresh start). EzyPlatform's admin UI has no restart action of
# its own, so instead of requiring a manual restart on Railway's dashboard,
# poll the directories that feed the classpath for changes and trigger our
# own restart automatically once a change looks settled (debounced so we
# don't restart mid-upload while a plugin zip is still being extracted).
watch_plugins() {
    admin_pid="$1"
    watch_dirs="admin/plugins web/plugins web/themes socket/plugins"
    fingerprint() {
        find $watch_dirs -type f -exec stat -c '%n %Y %s' {} \; 2>/dev/null | sort | sha1sum
    }
    prev="$(fingerprint)"
    while kill -0 "$admin_pid" 2>/dev/null; do
        sleep 10
        cur="$(fingerprint)"
        if [ "$cur" != "$prev" ]; then
            sleep 10
            settled="$(fingerprint)"
            if [ "$settled" = "$cur" ]; then
                echo "docker-entrypoint: plugin/theme change detected, restarting to apply it"
                kill "$admin_pid" 2>/dev/null
                exit 0
            fi
        fi
        prev="$cur"
    done
}

case "$1" in
    admin)
        run_admin
        ;;
    web)
        run_web
        ;;
    socket)
        run_socket
        ;;
    all)
        trap 'kill -TERM 0' TERM INT
        run_admin &
        ADMIN_PID=$!
        run_web &
        run_socket &
        watch_plugins "$ADMIN_PID" &
        wait -n
        exit $?
        ;;
    *)
        exec "$@"
        ;;
esac
