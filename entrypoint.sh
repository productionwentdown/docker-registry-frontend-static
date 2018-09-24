#!/bin/sh

BASE_URL=${BASE_URL:=/}

# REGISTRY_SCHEME can't be changed
REGISTRY_HOST=${REGISTRY_HOST:=localhost}
REGISTRY_PORT=${REGISTRY_PORT:=5000}

[[ "$MODE_BROWSE_ONLY" != "true" ]] && [[ "$MODE_BROWSE_ONLY" != "false" ]] && MODE_BROWSE_ONLY=false
DEFAULT_REPOSITORIES_PER_PAGE=${DEFAULT_REPOSITORIES_PER_PAGE:=20}
DEFAULT_TAGS_PER_PAGE=${DEFAULT_TAGS_PER_PAGE:=10}

sed -i "s~<base href=\"/\">~<base href=\"$BASE_URL\">~" /srv/index.html

cat > /etc/Caddyfile << EOF
:80$BASE_URL {
    root /srv
    browse

    rewrite {
        regexp (.*)
        to {1} {1}/ /
    }
}
EOF

cat > /srv/registry-host.json << EOF
{
    "host": "$REGISTRY_HOST",
    "port": $REGISTRY_PORT
}
EOF

cat > /srv/app-mode.json << EOF
{
    "browseOnly": $MODE_BROWSE_ONLY,
    "defaultRepositoriesPerPage": $DEFAULT_REPOSITORIES_PER_PAGE,
    "defaultTagsPerPage": $DEFAULT_TAGS_PER_PAGE
}
EOF

caddy -conf /etc/Caddyfile "$@"
