FROM eclipse-temurin:8-jre

ARG S6_OVERLAY_VERSION=3.2.3.2
ARG TARGETARCH

# s6-overlay doesn't pass the container's environment through to supervised
# services by default (RAILWAY_VOLUME_MOUNT_PATH, DB_HOST etc. would be
# invisible to admin/web/socket/watch-* otherwise) - S6_KEEP_ENV=1 makes it
# behave like a normal container where every process just sees docker's env.
ENV S6_KEEP_ENV=1

WORKDIR /ezyplatform

# s6-overlay supervises admin/web/socket as three independent processes in
# this one container: proper signal handling, clean shutdown, and safe
# restart-on-crash / restart-on-command, instead of a hand-rolled bash
# supervisor (which had real races around SIGTERM-during-shutdown and a
# set -e bug swallowing relaunches).
RUN apt-get update \
    && apt-get install -y --no-install-recommends xz-utils \
    && case "${TARGETARCH}" in \
        amd64) S6_ARCH=x86_64 ;; \
        arm64) S6_ARCH=aarch64 ;; \
        arm) S6_ARCH=armhf ;; \
        *) echo "unsupported arch: ${TARGETARCH}" >&2; exit 1 ;; \
    esac \
    && curl -fsSL -o /tmp/s6-overlay-noarch.tar.xz "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" \
    && curl -fsSL -o /tmp/s6-overlay-arch.tar.xz "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz" \
    && tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
    && tar -C / -Jxpf /tmp/s6-overlay-arch.tar.xz \
    && rm -f /tmp/s6-overlay-*.tar.xz \
    && apt-get purge -y xz-utils \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

COPY . /ezyplatform/
COPY s6-rc.d /etc/s6-overlay/s6-rc.d

RUN rm -rf /ezyplatform/docker-data /ezyplatform/logs/* \
    && mkdir -p /ezyplatform/admin/plugins /ezyplatform/web/plugins /ezyplatform/upload \
    && cp -a /ezyplatform/settings /ezyplatform/.seed-settings \
    && cp -a /ezyplatform/web/themes /ezyplatform/.seed-web-themes \
    && cp -a /ezyplatform/socket/plugins /ezyplatform/.seed-socket-plugins \
    && mkdir -p /ezyplatform/.seed-admin-plugins /ezyplatform/.seed-web-plugins \
    && chmod +x /ezyplatform/docker-entrypoint.sh /ezyplatform/watch-and-restart.sh \
    && chmod +x /etc/s6-overlay/s6-rc.d/admin/run /etc/s6-overlay/s6-rc.d/web/run /etc/s6-overlay/s6-rc.d/socket/run \
    && chmod +x /etc/s6-overlay/s6-rc.d/watch-admin/run /etc/s6-overlay/s6-rc.d/watch-web/run /etc/s6-overlay/s6-rc.d/watch-socket/run

ENTRYPOINT ["/ezyplatform/docker-entrypoint.sh"]
CMD ["all"]
