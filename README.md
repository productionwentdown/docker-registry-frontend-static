
# [docker-registry-frontend-static](https://hub.docker.com/r/productionwentdown/docker-registry-frontend-static/)

This image packs [`docker-registry-frontend`](https://github.com/brennerm/docker-registry-frontend) into a Caddy container. This container assumes that the registry is on the same path (`/v2/`) as the registry frontend, and uses a bunch of hacks to modify the source from `docker-registry-frontend` to work with a different base URL.

# Usage

```
docker-compose.yml:

...
  registry:
    image: registry:2
    restart: always
    networks:
    - management
    volumes:
    - /data/registry:/var/lib/registry
    labels:
    - "traefik.enable=true"
    - "traefik.frontend.rule=Host:example.com;PathPrefix:/v2/"
    - "traefik.frontend.entryPoints=https"
    - "traefik.frontend.auth.basic=user:hashed_password"
    - "traefik.port=5000"
    
  registry-viewer:
    image: productionwentdown/docker-registry-frontend-static
    restart: always
    networks:
    - management
    environment:
    - BASE_URL=/registry/
    - REGISTRY_HOST=example.com
    - REGISTRY_PORT=443
    labels:
    - "traefik.enable=true"
    - "traefik.frontend.rule=Host:example.com;PathPrefix:/registry/"
    - "traefik.frontend.entryPoints=https"
    - "traefik.port=80"
```

> TODO: More usage examples. For now, see [`entrypoint.sh`](entrypoint.sh).
