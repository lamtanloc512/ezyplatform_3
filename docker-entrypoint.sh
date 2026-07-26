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

# Plugin/theme installs AND activate/deactivate both need a process restart
# to take effect (Java's -cp classpath is fixed at JVM boot; activate state
# lives in .runtime/<service>/*.txt, e.g. .runtime/web/themes.txt, which is
# a plain file write too - not a DB row, so watching files catches both).
# EzyPlatform's admin UI has no restart action that reliably reaches our
# process, so instead of a manual restart on Railway's dashboard, each
# service supervises itself: watches only ITS OWN directories and restarts
# only itself when they change (settled, debounced ~10s so we don't restart
# mid-upload) - so e.g. a web theme change never disturbs admin or socket.
SHUTTING_DOWN=0

supervise() {
    name="$1"; run_fn="$2"; shift 2
    watch_dirs="$*"
    fingerprint() {
        find $watch_dirs -type f -exec stat -c '%n %Y %s' {} \; 2>/dev/null | sort | sha1sum
    }
    while [ "$SHUTTING_DOWN" = "0" ]; do
        "$run_fn" &
        pid=$!
        prev="$(fingerprint)"
        while [ "$SHUTTING_DOWN" = "0" ] && kill -0 "$pid" 2>/dev/null; do
            sleep 10
            cur="$(fingerprint)"
            if [ "$cur" != "$prev" ]; then
                sleep 10
                settled="$(fingerprint)"
                if [ "$settled" = "$cur" ]; then
                    echo "docker-entrypoint: $name plugin/theme change detected, restarting $name only"
                    kill "$pid" 2>/dev/null || true
                fi
            fi
            prev="$cur"
        done
        # `wait` can return early if this subshell catches a trapped signal
        # mid-wait (e.g. the container-wide SIGTERM below), before the child
        # has actually released its port - confirm it's truly gone before
        # ever considering a relaunch, or two instances briefly race to
        # bind the same port and one crashes.
        wait "$pid" 2>/dev/null || true
        while kill -0 "$pid" 2>/dev/null; do
            sleep 1
        done
        [ "$SHUTTING_DOWN" = "1" ] && break
        echo "docker-entrypoint: $name exited, relaunching"
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
        # SHUTTING_DOWN is set here, in the trap, before the supervise
        # subshells are forked below, so each one inherits this exact trap
        # and - since each subshell has its own copy of the variable - sets
        # its own SHUTTING_DOWN when the signal reaches it, telling its loop
        # to exit cleanly instead of relaunching mid-shutdown.
        trap 'SHUTTING_DOWN=1; kill -TERM 0' TERM INT
        supervise admin run_admin admin/plugins .runtime/admin &
        supervise web run_web web/plugins web/themes .runtime/web &
        supervise socket run_socket socket/plugins .runtime/socket &
        wait
        ;;
    *)
        exec "$@"
        ;;
esac
