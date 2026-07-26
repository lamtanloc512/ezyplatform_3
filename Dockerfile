FROM eclipse-temurin:8-jre

WORKDIR /ezyplatform

COPY . /ezyplatform/

RUN rm -rf /ezyplatform/docker-data /ezyplatform/logs/* \
    && mkdir -p /ezyplatform/admin/plugins /ezyplatform/web/plugins /ezyplatform/upload \
    && cp -a /ezyplatform/settings /ezyplatform/.seed-settings \
    && cp -a /ezyplatform/web/themes /ezyplatform/.seed-web-themes \
    && cp -a /ezyplatform/socket/plugins /ezyplatform/.seed-socket-plugins \
    && mkdir -p /ezyplatform/.seed-admin-plugins /ezyplatform/.seed-web-plugins \
    && chmod +x /ezyplatform/docker-entrypoint.sh

ENTRYPOINT ["/ezyplatform/docker-entrypoint.sh"]
CMD ["all"]
