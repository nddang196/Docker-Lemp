ARG VERSION=7.0

FROM php:${VERSION}-fpm-alpine

MAINTAINER VooThanh DEV <voothanhphong@gmail.com>

ENV ROOT_FOLDER /project
ENV IS_ACTIVE_XDEBUG 0
ENV DOCKER_DESKTOP 0

# Update and add install
RUN apk update && \
        apk add bash && \
        apk add --no-cache --virtual .build-deps \
        		$PHPIZE_DEPS \
        		autoconf \
        		libjpeg-turbo-dev \
        		libmemcached-dev \
        		libpng-dev \
        		openldap-dev \
        		pcre-dev \
        		postgresql-dev \
        		libxml2-dev \
        		libxslt-dev \
        		libzip-dev \
        		icu-dev \
                iproute2

# Configure the gd library
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/; \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl; \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu; \
    docker-php-ext-configure opcache --enable-opcache; \
    docker-php-ext-configure zip --with-libzip; \
    \
    # install ext
    docker-php-ext-install -j "$(nproc)" \
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
    recode \
    shmop \
    soap \
    sockets \
    sysvmsg \
    sysvsem \
    sysvshm \
    tidy \
    xmlrpc \
    xsl \
    zip; \
    pecl install -o -f xdebug; \
    pecl install -o -f redis; \
    docker-php-ext-enable redis

# Update php config
COPY ini /usr/local/etc/php/conf.d/
COPY pool /usr/local/etc/php-fpm.d/
COPY php7_1_ext.sh /

RUN chmod +x /php7_1_ext.sh && /php7_1_ext.sh

# Install composer
RUN curl -sS https://getcomposer.org/installer | \
		php -- --install-dir=/usr/local/bin --filename=composer \
	&& composer global require hirak/prestissimo \
    && composer global require "squizlabs/php_codesniffer=*"

COPY ./entrypoint.sh /
RUN sed -i -e 's/\r$//' /entrypoint.sh \
    && chmod +x /entrypoint.sh \
    \
    # Download magerun n98
    && curl -O https://files.magerun.net/n98-magerun2.phar \
    && chmod +x n98-magerun2.phar \
    && mv n98-magerun2.phar /usr/bin/m2 \
    \
    # Remove cache
    && rm -rf /tmp/pear \
    && rm -rf /var/cache/apk/*

ENTRYPOINT ["/entrypoint.sh"]

VOLUME /root/.composer/cache

WORKDIR ${ROOT_FOLDER}

EXPOSE 9000

CMD ["php-fpm", "-R"]
