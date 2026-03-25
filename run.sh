#!/usr/bin/with-contenv bash
set -euo pipefail

TOKEN="$(bashio::config 'token')"

if [[ -z "${TOKEN}" ]]; then
  echo "Token is required"
  exit 1
fi

exec /usr/local/bin/cloudflared tunnel --no-autoupdate run --token "${TOKEN}"
