FROM php:5.6-fpm
MAINTAINER Erwin Mueller "erwin.mueller@deventm.de"

# the phpMyAdmin version
ENV PHPMYADMIN_VERSION 4.6.2

# www user, should aready exist
RUN set -x \
    && if ! id www-data; then \ 
    useradd -rU www-data; \
    fi

# optional add proxy entries for apt
RUN set -x \
    && [ -n \"${http_proxy}\" ] && echo Acquire::http::Proxy \"$http_proxy\"; >> /etc/apt/apt.conf.d/08proxy && true \
    && [ -n \"${ftp_proxy}\" ] && echo Acquire::ftp::Proxy \"$ftp_proxy\"; >> /etc/apt/apt.conf.d/08proxy && true

# install tools and dependencies
RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
                        libbz2-dev \
                        zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \

# install php extensions
RUN docker-php-ext-install bz2
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install zip
RUN docker-php-ext-install opcache

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=60'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# download and install phpMyAdmin
RUN set -x \
    && apt-get update \
    && apt-get install -y \
                        wget \
                        tar \
                        xz-utils \
                        gnupg \
    # work in temp
    && cd /tmp \
    
    # download archive
    && wget https://files.phpmyadmin.net/phpMyAdmin/$PHPMYADMIN_VERSION/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.xz \
    && wget https://files.phpmyadmin.net/phpMyAdmin/$PHPMYADMIN_VERSION/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.xz.asc \
    && wget https://files.phpmyadmin.net/phpmyadmin.keyring \
    
    # verify download
    && gpg --import phpmyadmin.keyring \
    && gpg --keyserver hkp://pgp.mit.edu --recv-keys 8259BD92 \
    && gpg --verify phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.xz.asc \
    
    # extract archive
    && mkdir -p /usr/src/ \
    && tar xf phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.xz -C /usr/src/ \
    && chown root.root -R /usr/src/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages \
    && ln -s /usr/src/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages /usr/src/phpMyAdmin \
    
    # clean up
    && rm phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.xz \
    && rm phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.xz.asc \
    && rm phpmyadmin.keyring \
    && apt-get remove --auto-remove -y wget xz-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# copy configuration
COPY htaccess /usr/src/phpMyAdmin/.htaccess
COPY config.inc.php /usr/src/phpMyAdmin/config.inc.php
COPY config.inc.php /usr/src/phpMyAdmin/config.inc.php.custom

# phpMyAdmin directory
VOLUME /var/www/html

# expose php-fpm port
EXPOSE 9000/tcp

# add entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN set -x \
    && chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# run php
CMD ["php-fpm"]
