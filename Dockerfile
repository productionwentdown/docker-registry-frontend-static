FROM alpine:3.8

COPY --from=productionwentdown/caddy /bin/caddy /usr/local/bin/caddy
COPY --from=konradkleine/docker-registry-frontend:v2 /var/www/html /srv/

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
