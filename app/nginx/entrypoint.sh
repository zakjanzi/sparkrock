#!/bin/sh
set -e

# If passed via env (ECS case), write it
if [ -n "$HTPASSWD_BCRYPT" ]; then
  echo "$HTPASSWD_BCRYPT" > /etc/nginx/.htpasswd
fi

# If no file present, bail out clearly
if [ ! -s /etc/nginx/.htpasswd ]; then
  echo "ERROR: /etc/nginx/.htpasswd missing. Set HTPASSWD_BCRYPT or mount a file." >&2
  exit 1
fi

exec nginx -g 'daemon off;'
