#!/bin/bash
# Prepares the app directory then starts the requested service:
# admin | web | socket | all (all three, supervised by s6-overlay).
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
# In "all" mode, admin/web/socket each invoke this same script (see
# s6-rc.d/*/run), so the seeding below is guarded by a mkdir-based lock -
# mkdir is atomic, so exactly one of them performs it while the others wait.
#
# Without RAILWAY_VOLUME_MOUNT_PATH (plain docker-compose), we run in place
# from /ezyplatform and expect the narrow per-directory bind mounts in
# docker-compose.yml, seeded here from the .seed-* copies baked at build time.
set -e

# Without an explicit cap, each JVM defaults to letting itself use up to 25%
# of the *whole container's* memory (independently, not divided between
# them) - three JVMs can then combine toward 75%+ of container memory just
# for heaps, which reads as an ever-climbing "leak" on a memory graph even
# though it's just normal (uncapped) JVM ergonomics.
#
# Sized from real VPS usage: ~2GB steady-state, ~3GB peak during deploy for
# admin+web+socket combined. 1GB heap ceiling per JVM = 3GB combined ceiling,
# matching that observed peak, while steady usage should sit near the
# observed ~2GB since Java only grows toward -Xmx under actual pressure.
# Needs a Railway plan with headroom above 3GB for non-heap overhead
# (metaspace, thread stacks, JIT code cache - typically some hundreds of MB
# combined across 3 JVMs) - 4GB+ is the practical minimum. Override
# JAVA_OPTS yourself if your service split isn't roughly even.
: "${JAVA_OPTS:=-Xms256m -Xmx1024m}"

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
    LOCK_DIR="$DATA_DIR/.seed.lock"
    mkdir -p "$DATA_DIR"
    if mkdir "$LOCK_DIR" 2>/dev/null; then
        mkdir -p "$APP_DIR"
        if [ -z "$(ls -A "$APP_DIR" 2>/dev/null)" ]; then
            cp -a /ezyplatform/. "$APP_DIR/"
        fi
        rmdir "$LOCK_DIR"
    else
        while [ -d "$LOCK_DIR" ]; do sleep 1; done
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
        # Hand off to s6-overlay's init, which reads /etc/s6-overlay/s6-rc.d
        # (copied in at build time) to supervise admin/web/socket plus a
        # watcher per service that restarts it when its plugin/theme files
        # change - see s6-rc.d/ and watch-and-restart.sh.
        exec /init
        ;;
    *)
        exec "$@"
        ;;
esac
