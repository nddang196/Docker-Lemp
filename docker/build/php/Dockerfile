ARG VERSION=7.3

FROM php:${VERSION}-fpm

MAINTAINER VoThanh Phong <nddang196@gmail.com>

ENV ENABLE_SENDMAIL 'true'
ENV ROOT_FOLDER /project
ENV IS_ACTIVE_XDEBUG false

# Update and add install
RUN apt-get update && \
	apt-get install -y \
	 	libfreetype6-dev \
	    libicu-dev \
	    libjpeg62-turbo-dev \
	    libmcrypt-dev \
	    libpng-dev \
	    libxslt1-dev \
	    sendmail-bin \
	    sendmail \
	    sudo \
	    git \
	    cron \
	    unzip \
	    curl \
	    iproute2

# Configure the gd library
RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

# Install required PHP extensions
RUN docker-php-ext-install dom gd intl mbstring pdo_mysql xsl zip bcmath soap sockets opcache mcrypt pcntl

RUN pecl install -o -f xdebug

# Update php config
COPY ./config/*.ini /usr/local/etc/php/conf.d/

COPY ./entrypoint.sh /
RUN sed -i -e 's/\r$//' /entrypoint.sh && chmod +x /entrypoint.sh

RUN if [ -e /usr/local/etc/php-fpm.d/zz-docker.conf ]; then \
		sed -i "s/listen = 9000/listen = [::]:9000/g" /usr/local/etc/php-fpm.d/zz-docker.conf; \
	fi

# Create user docker add to group www-data
RUN useradd -u 1000 -ms /bin/bash -g www-data www

# Install composer
RUN curl -sS https://getcomposer.org/installer | \
		php -- --install-dir=/usr/local/bin --filename=composer
RUN su - www -c "composer global require hirak/prestissimo"
RUN su - www -c "composer global require \"squizlabs/php_codesniffer=*\""

# Download magerun n98
RUN curl -O https://files.magerun.net/n98-magerun2.phar
RUN chmod +x n98-magerun2.phar
RUN mv n98-magerun2.phar /usr/bin/mgt

RUN rm -rf /tmp/pear
RUN rm -rf /var/lib/apt/lists/*

RUN chown -R www /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

WORKDIR ${ROOT_FOLDER}

EXPOSE 9000

CMD ["php-fpm", "-R"]