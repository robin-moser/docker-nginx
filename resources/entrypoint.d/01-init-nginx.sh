#!/command/with-contenv sh

set -e

# nginx server config directory
SERVER_DIR=/etc/nginx/server.d

# if root domain isn't set, set domain variable to the default
# "catch all" underscore and delete the special redirect server config
if [ -z "$NGINX_DOMAIN" ]; then

    NGINX_DOMAIN="_"
    rm "$SERVER_DIR/20-redirect.conf"

fi

# replace the template variables in every server config
for file in $SERVER_DIR/*; do

    echo "$file"

    sed -i "s#<NGINX_DOMAIN>#$NGINX_DOMAIN#" "$file"
    sed -i "s#<NGINX_WEB_ROOT>#$NGINX_WEB_ROOT#" "$file"
    sed -i "s#<NGINX_INDEX>#$NGINX_INDEX#" "$file"

done
