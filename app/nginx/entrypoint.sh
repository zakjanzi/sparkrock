#!/bin/sh
set -e
# Expect HTPASSWD_BCRYPT
if [ -n "$HTPASSWD_BCRYPT" ]; then
  echo "$HTPASSWD_BCRYPT" > /etc/nginx/.htpasswd
else
  echo "WARNING: HTPASSWD_BCRYPT not set; Basic Auth will reject everyone" >&2
  # wrote a dummy impossible hash so auth still enforced
  echo 'sparkrock:$2y$10$ABCDEFGHIJKLMNOPQRSTUV/abcdefghijklmnopqrstuv1234567890abcdef' > /etc/nginx/.htpasswd
fi
exec nginx -g 'daemon off;'
#!/bin/sh
set -e
# Expect HTPASSWD_BCRYPT
if [ -n "$HTPASSWD_BCRYPT" ]; then
  echo "$HTPASSWD_BCRYPT" > /etc/nginx/.htpasswd
else
  echo "WARNING: HTPASSWD_BCRYPT not set; Basic Auth will reject everyone" >&2
  # wrote a dummy impossible hash so auth still enforced
  echo 'sparkrock:$2y$10$ABCDEFGHIJKLMNOPQRSTUV/abcdefghijklmnopqrstuv1234567890abcdef' > /etc/nginx/.htpasswd
fi
exec nginx -g 'daemon off;'
