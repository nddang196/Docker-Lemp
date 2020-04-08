#!/usr/bin/env bash

currentVersion=$(php -v | awk 'NR==1 {print $2}');
arr=($(echo ${currentVersion} | tr '.' "\\n"));
if [ ${arr[0]} -lt 7 ]; then
    apt-get -y install libmcrypt-dev
	docker-php-ext-install mcrypt pcntl;
elif [ ${arr[0]} -eq 7 ]; then
    if [ ${arr[1]} -lt 4 ]; then
        apt-get -y install librecode0 librecode-dev;
        docker-php-ext-configure zip --with-libzip;
        docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
	    docker-php-ext-install recode;
	else
	    docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/
    fi

    if [ ${arr[1]} -lt 3 ]; then
        pecl install -o -f xdebug-2.6.1;
    else
        pecl install -o -f xdebug-2.7.1
    fi

    if [ ${arr[1]} -lt 2 ]; then
        apt-get -y install libmcrypt-dev;
	    docker-php-ext-install mcrypt pcntl;
    fi
fi