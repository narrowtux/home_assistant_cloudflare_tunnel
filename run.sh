#!/usr/bin/with-contenv bashio
set -euo pipefail

TOKEN="$(bashio::config 'token')"

if bashio::var.is_empty "${TOKEN}"; then
    bashio::log.fatal "Token is required"
fi

exec /usr/local/bin/cloudflared tunnel --no-autoupdate run --token "${TOKEN}"
