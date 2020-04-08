ARG VERSION=7.0

FROM php:${VERSION}-fpm

MAINTAINER VooThanh DEV <voothanhphong@gmail.com>

ENV ROOT_FOLDER /project
ENV IS_ACTIVE_XDEBUG false
ENV ENABLE_CRON false
ENV ENABLE_SENDMAIL false

# Update and add install
RUN apt-get update && \
	apt-get install -y --no-install-recommends sendmail-bin \
                                               sendmail \
                                               libbz2-dev \
                                               libjpeg62-turbo-dev \
                                               libpng-dev \
                                               libfreetype6-dev \
                                               libgeoip-dev \
                                               libgmp-dev \
                                               libmagickwand-dev \
                                               libmagickcore-dev \
                                               libc-client-dev \
                                               libkrb5-dev \
                                               libicu-dev \
                                               libldap2-dev \
                                               libpspell-dev \
                                               libtidy-dev \
                                               libxslt1-dev \
                                               libyaml-dev \
                                               libzip-dev \
                                               zip \
                                               curl \
                                               cron \
                                               iproute2

COPY ext-by-version.sh /
RUN chmod +x /ext-by-version.sh && /ext-by-version.sh

# Configure the ext library
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu
RUN docker-php-ext-configure opcache --enable-opcache

# Install required PHP extensions
RUN docker-php-ext-install -j$(nproc) \
                            bcmath \
                            bz2 \
                            calendar \
                            exif \
                            gd \
                            gettext \
                            gmp \
                            imap \
                            intl \
                            ldap \
                            mysqli \
                            opcache \
                            pdo_mysql \
                            pspell \
                            shmop \
                            soap \
                            sockets \
                            sysvmsg \
                            sysvsem \
                            sysvshm \
                            tidy \
                            xmlrpc \
                            xsl \
                            pcntl \
                            zip

RUN pecl install -o -f redis \
                       geoip-1.1.1
RUN docker-php-ext-enable redis \
                          geoip

# Update php config
COPY ini /usr/local/etc/php/conf.d/
COPY pool /usr/local/etc/php-fpm.d/

COPY ./entrypoint.sh /
RUN sed -i -e 's/\r$//' /entrypoint.sh && chmod +x /entrypoint.sh

# Install composer
RUN curl -sS https://getcomposer.org/installer | \
		php -- --install-dir=/usr/local/bin --filename=composer \
    && composer global require "hirak/prestissimo" \
    && composer global require "squizlabs/php_codesniffer=*"

# Download magerun n98
RUN curl -O https://files.magerun.net/n98-magerun2.phar && \
    chmod +x n98-magerun2.phar && \
    mv n98-magerun2.phar /usr/bin/m2

RUN rm -rf /tmp/* && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/entrypoint.sh"]

VOLUME /root/.composer/cache

WORKDIR ${ROOT_FOLDER}

EXPOSE 9000

CMD ["php-fpm", "-R"]
