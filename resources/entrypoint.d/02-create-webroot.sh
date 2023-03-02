#!/command/with-contenv sh

set -e

# create webroot
mkdir -p "$NGINX_WEB_ROOT"

# set group and owner to application
chmod 750 "$NGINX_WEB_ROOT"
chown application:application "$NGINX_WEB_ROOT"
