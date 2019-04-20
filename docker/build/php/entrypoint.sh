#!/bin/bash

set -e

mkdir -p ${ROOT_FOLDER}

# Update php config
if [[ ! -z "${CONFIG}" ]]; then
	CONFIG=$(echo ${CONFIG})
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
    hostIp=$(ip route | awk 'NR==1 {print $3}') # Get current ip address
    hostIp=($(echo ${hostIp} | tr '.' "\n")) # convert to array
    getway=${hostIp[0]}.${hostIp[1]}.0.1

    sed -i "/xdebug.remote_host/d" /usr/local/etc/php/conf.d/z-xdebug.ini
	printf "\nxdebug.remote_host=${getway}" >> /usr/local/etc/php/conf.d/z-xdebug.ini

    docker-php-ext-enable xdebug
    echo 'Xdebug enabled'
fi

# Config send mail
if [[ "$ENABLE_SENDMAIL" == "true" ]]; then
    /etc/init.d/sendmail start
fi

exec "$@"