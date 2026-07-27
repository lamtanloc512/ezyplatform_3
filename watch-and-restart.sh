#!/bin/bash
# Plugin/theme installs AND activate/deactivate both need a process restart
# to take effect (Java's -cp classpath is fixed at JVM boot; activate state
# lives in .runtime/<service>/*.txt, e.g. .runtime/web/themes.txt, which is
# a plain file write too - not a DB row, so watching files catches both).
# EzyPlatform's admin UI has no restart action that reliably reaches our
# process, so instead of a manual restart on Railway's dashboard, each
# service is watched independently and restarted only itself when its own
# directories change (settled, debounced ~10s so we don't restart mid
# upload) - so e.g. a web theme change never disturbs admin or socket.
#
# Restarting is delegated to s6-svc -r, which safely kills the old instance
# and waits for it to fully exit before s6 starts a new one - avoiding the
# port-bind races a hand-rolled kill/wait/relaunch loop hit.
set -e

name="$1"; shift
watch_dirs="$*"

DATA_DIR="${RAILWAY_VOLUME_MOUNT_PATH:-}"
if [ -n "$DATA_DIR" ]; then
    cd "$DATA_DIR/app"
else
    cd /ezyplatform
fi

fingerprint() {
    find $watch_dirs -type f -exec stat -c '%n %Y %s' {} \; 2>/dev/null | sort | sha1sum
}

prev="$(fingerprint)"
while true; do
    sleep 10
    cur="$(fingerprint)"
    if [ "$cur" != "$prev" ]; then
        sleep 10
        settled="$(fingerprint)"
        if [ "$settled" = "$cur" ]; then
            echo "watch-and-restart: $name plugin/theme change detected, restarting $name only"
            s6-svc -r /run/service/"$name"
        fi
    fi
    prev="$cur"
done
