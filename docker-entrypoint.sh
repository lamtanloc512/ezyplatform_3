#!/bin/bash
# Starts the requested service: admin | web | socket | all (all three in one
# container, for a single-service Railway deployment).
#
# EzyPlatform treats its whole install directory as mutable, self-updating
# state (update.sh overwrites admin/lib, web/lib, socket/lib, lib/, resources
# etc.; the admin UI writes plugin jars under admin/plugins, web/plugins).
# So on Railway, RAILWAY_VOLUME_MOUNT_PATH's volume holds the *entire* app
# (like a VPS install disk), seeded from the image once on first boot only.
# On every later boot the volume's copy is authoritative and is NOT
# resynced from the image - platform/plugin updates must be applied against
# the live volume (via EzyPlatform's own updater), not by redeploying.
#
# Without RAILWAY_VOLUME_MOUNT_PATH (plain docker-compose), we run in place
# from /ezyplatform and expect the narrow per-directory bind mounts in
# docker-compose.yml, seeded here from the .seed-* copies baked at build time.
set -e

# Without an explicit heap cap, each JVM independently sizes itself against
# all memory it can see (~25% default). Three of them in one container can
# easily overcommit and get SIGKILL'd by the OOM killer. Override JAVA_OPTS
# yourself for a bigger/smaller footprint; this is just a safe default.
: "${JAVA_OPTS:=-Xms64m -Xmx256m}"

seed() {
    src="$1"; dst="$2"
    if [ -d "$dst" ] && [ -z "$(ls -A "$dst" 2>/dev/null)" ]; then
        cp -a "$src/." "$dst/" 2>/dev/null || true
    fi
}

DATA_DIR="${RAILWAY_VOLUME_MOUNT_PATH:-}"

if [ -n "$DATA_DIR" ]; then
    APP_DIR="$DATA_DIR/app"
    mkdir -p "$APP_DIR"
    if [ -z "$(ls -A "$APP_DIR" 2>/dev/null)" ]; then
        cp -a /ezyplatform/. "$APP_DIR/"
    fi
    cd "$APP_DIR"
    mkdir -p logs upload admin/plugins web/plugins
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
        trap 'kill -TERM 0' TERM INT
        run_admin &
        run_web &
        run_socket &
        wait -n
        exit $?
        ;;
    *)
        exec "$@"
        ;;
esac
