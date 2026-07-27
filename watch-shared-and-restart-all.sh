#!/bin/bash
# lib/ (and external/, if present) feed every service's classpath - see
# CP="lib/*:external/lib/*:..." in run_admin/run_web/run_socket. EzyPlatform's
# own self-updater (update.sh) overwrites this shared core along with each
# service's own lib/resources/settings (see update-files.txt), so unlike a
# single plugin install, a core update needs all three services restarted,
# not just one.
set -e

watch_dirs="lib external"

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
            echo "watch-shared: core lib/ change detected, restarting admin+web+socket"
            s6-svc -r /run/service/admin
            s6-svc -r /run/service/web
            s6-svc -r /run/service/socket
        fi
    fi
    prev="$cur"
done
