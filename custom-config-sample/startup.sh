#!/bin/sh

create_custom_configuration() {
cat <<EOF
{
    "someValue": [
        {"name": "myApi", "url": "${SOME_ENV_VARIABLE}/"}             
    ]
}
EOF
}

create_custom_configuration > /usr/share/nginx/html/assets/config/config.json # create the configuration file using substitutions

cat /usr/share/nginx/html/assets/config/config.json # show the configuration for debug purposes

/usr/sbin/nginx -g 'daemon off;' # start an NGINX server
