#!/bin/bash

set -e

mkdir -p ${ROOT_FOLDER}

# Update php config
if [[ ! -z "${CONFIG}" ]]; then
	CONFIG=($(echo ${CONFIG} | tr ',' "\n"))
	for item in ${CONFIG[@]}
	do
		item=($(echo ${item} | tr '=' "\n"))
	    configName=$(echo "${item[0]}" | tr '[:upper:]' '[:lower:]')
	    configValue=${item[1]}

	    sed -i "/${configName}/d" /usr/local/etc/php/conf.d/zz-docker.ini
		printf "\n${configName} = ${configValue}" >> /usr/local/etc/php/conf.d/zz-docker.ini
	done
fi

# Config xdebug
if [[ "$IS_ACTIVE_XDEBUG" == "true" ]]; then
    docker-php-ext-enable xdebug
    echo 'Xdebug enabled'
fi

# Config send mail
if [[ "$ENABLE_SENDMAIL" == "true" ]]; then
    /etc/init.d/sendmail start
fi

exec "$@"