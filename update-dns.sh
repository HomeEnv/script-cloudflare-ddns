#!/usr/bin/env sh
set -eu

# install tools once
apk add --no-cache curl jq

# forever loop
while true; do
  IP=$(curl -s https://api.ipify.org)

  PAYLOAD=$(printf '{
    "type":"A",
    "name":"%s",
    "content":"%s",
    "ttl":120,
    "proxied":false
  }' "$CF_RECORD_NAME" "$IP")

  # update record
  curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records/${CF_RECORD_ID}" \
       -H "Authorization: Bearer ${CF_TOKEN}" \
       -H "Content-Type: application/json" \
       --data "$PAYLOAD"

  echo "$(date '+%Y-%m-%d %H:%M:%S') updated $CF_RECORD_NAME → $IP"
  sleep "${SLEEP_INTERVAL:-300}"
done
