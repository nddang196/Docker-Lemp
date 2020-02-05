#!/usr/bin/env bash

currentVersion=$(php -v | awk 'NR==1 {print $2}');
arr=($(echo ${currentVersion} | tr '.' "\\n"));
if [ ${arr[0]} -eq 7 ] && [ ${arr[1]} -lt 2 ] || [ ${arr[0]} -lt 7 ]; then
    apk add --no-cache libmcrypt-dev
	docker-php-ext-install mcrypt pcntl;
fi