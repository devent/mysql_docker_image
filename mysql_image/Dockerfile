FROM mysql:5.7
MAINTAINER Erwin Mueller "erwin.mueller@nttdata.com"

# copy configuration
COPY my.cnf /etc/mysql/my.cnf.custom
COPY my.cnf /etc/mysql/my.cnf

# configuration is ignored if writable
RUN set -x \
    && chmod a-wx /etc/mysql/my.cnf

# save parent's entrypoint script
RUN set -x \
    && mv /usr/local/bin/docker-entrypoint.sh /usr/local/bin/mysql-docker-entrypoint.sh

# copy custom entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN set -x \
    && chmod a-w /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

# set entrypoint script
ENTRYPOINT ["docker-entrypoint.sh"]

# database data files
VOLUME /var/lib/mysql

# expose database port
EXPOSE 3306

# run mysqld
CMD ["mysqld"]
