#!/bin/bash

# Support for stopping container with `Ctrl+C`
set -ex

# if command starts with an option, prepend run command
RUN_COMMAND=php-fpm
if [ "${1:0:1}" = '-' ]; then
    set -- $RUN_COMMAND "$@"
fi

# Add local user;
# Either use the 
# - PHPMYADMIN_USER_ID and
# - PHPMYADMIN_GROUP_ID
# if passed in at runtime or fallback.
USER_ID=${PHPMYADMIN_USER_ID:-9001}
GROUP_ID=${PHPMYADMIN_GROUP_ID:-9001}
echo "Starting with UID and GID: $USER_ID:$GROUP_ID"
usermod -u $USER_ID www-data
groupmod -g $GROUP_ID www-data

# remove eventual lost+found directory from the data folder
if [ -d '/var/www/html/lost+found' ]; then
    rm -rf '/var/www/html/lost+found'
fi

# installing phpMyAdmin
cd /var/www/html
if ! [ -e index.php -a -e phpmyadmin.css.php ]; then
    echo >&2 "phpMyAdmin not found in $(pwd) - copying now..."
    tar cf - --one-file-system -C /usr/src/phpMyAdmin . | tar xf -
    echo >&2 "Complete! phpMyAdmin has been successfully copied to $(pwd)"
    chown root.root -R .
fi

# fix permissions
cp config.inc.php.custom config.inc.php
chown www-data:www-data config.inc.php*
chmod u=r,g=r,o-rwx config.inc.php*
# setup blowfish_secret
SECRET=`TERM=dumb echo '<?php print hash("sha512", openssl_random_pseudo_bytes(1000));' | php -- `
sed -i -r "s/(\\\$cfg\['blowfish_secret'\]\s*=\s*)'.*'(;.*)/\1'${SECRET}'\2/" config.inc.php

# run command
exec "$@"
