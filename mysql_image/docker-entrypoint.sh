#!/bin/bash
set -x

# Add local user;
# Either use the MYSQL_USER_ID if passed in at runtime or fallback.
USER_ID=${MYSQL_USER_ID:-9001}
GROUP_ID=${MYSQL_GROUP_ID:-9001}
echo "Starting with UID: $USER_ID GID: $GROUP_ID"
usermod -u $USER_ID mysql
groupmod -g $GROUP_ID mysql

# update permissions
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# remove eventual lost+found directory from the data folder
if [ -d '/var/lib/mysql/lost+found' ]; then
    rm -rf '/var/lib/mysql/lost+found'
fi

# copy custom mysql configuration
cp /etc/mysql/my.cnf.custom /etc/mysql/my.cnf

# run parent's entrypoint script
mysql-docker-entrypoint.sh "$@"
