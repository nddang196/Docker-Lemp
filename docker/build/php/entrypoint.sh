#!/bin/bash

set -e

mkdir -p ${ROOT_FOLDER}

# Update php config
if [[ ! -z "${PHP_CONFIG}" ]]; then
	CONFIG=$(echo ${PHP_CONFIG})
	for item in ${CONFIG[@]}
	do
		item=($(echo ${item} | tr '=' "\n"))
	    configName=$(echo "${item[0]}" | tr '[:upper:]' '[:lower:]')
	    configValue=${item[1]}

	    sed -i "/${configName}/d" /usr/local/etc/php/conf.d/zz-docker.ini
		printf "\n${configName} = ${configValue}" >> /usr/local/etc/php/conf.d/zz-docker.ini
	    sed -i '/^$/d' /usr/local/etc/php/conf.d/zz-docker.ini
	done
fi

# Update php-fpm pool
if [[ ! -z "${FPM_POOL}" ]]; then
	POOL=$(echo ${FPM_POOL})
	for item in ${POOL[@]}
	do
		  item=($(echo ${item} | tr '=' "\n"))
	    configName=$(echo "${item[0]}" | tr '[:upper:]' '[:lower:]')
	    configValue=${item[1]}

	    sed -i "/${configName}/d" /usr/local/etc/php-fpm.d/zz-docker.conf
      printf "\n${configName} = ${configValue}" >> /usr/local/etc/php-fpm.d/zz-docker.conf
      sed -i '/^$/d' /usr/local/etc/php-fpm.d/zz-docker.conf
	done
fi

# Config xdebug
if [[ "${IS_ACTIVE_XDEBUG}" == "true" ]]; then
    hostIp=$(ip route | awk 'NR==1 {print $3}') # Get current ip address

    sed -i "/xdebug.remote_host/d" /usr/local/etc/php/conf.d/z-xdebug.ini
    printf "\nxdebug.remote_host=${hostIp}" >> /usr/local/etc/php/conf.d/z-xdebug.ini
    sed -i '/^$/d' /usr/local/etc/php/conf.d/z-xdebug.ini

    docker-php-ext-enable xdebug
    echo 'Xdebug enabled'
fi

# Config cron
if [[ "${ENABLE_CRON}" == "true" ]]; then
    /etc/init.d/cron start
fi

exec "$@"