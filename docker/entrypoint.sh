#!/bin/sh

set -e

MODE="$1"
shift

EMAIL=${EMAIL:-"default@example.com"}
DOMAIN=${DOMAIN:-"example.com"}

case "$MODE" in
  certonly)
    exec certbot certonly \
      --agree-tos \
      --no-eff-email \
      --email "$EMAIL" \
      --manual \
      --preferred-challenges dns \
      --manual-auth-hook /opt/certbot/auth-hook.py \
      --manual-cleanup-hook /opt/certbot/cleanup-hook.py \
      -d "*.$DOMAIN" "$@"
    ;;
  renew)
    exec certbot renew \
        --manual-auth-hook /opt/certbot/auth-hook.py \
        --manual-cleanup-hook /opt/certbot/cleanup-hook.py "$@"
    ;;
  *)
    echo "Unknown mode: $MODE"
    echo "Usage: docker run ... certonly|renew [extra certbot args]"
    exit 1
    ;;
esac