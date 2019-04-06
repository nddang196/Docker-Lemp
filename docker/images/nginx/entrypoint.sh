#!/bin/bash

set -e

mkdir -p ${ROOT_FOLDER}

# Config V-Host
if [[ ! -e /etc/nginx/conf.d/vhost.conf && ${SERVER_NAME} != '' ]]; then
    if [[ "${IS_MAGENTO}" != "true" ]]; then # Not Magento
        if [[ "${IS_HTTPS}" != "true" ]]; then # Not use https
            cp -f /etc/nginx/vhost/mysite.conf /vhost.conf
        else # Use https
            cp -f /etc/nginx/vhost/https/mysite.conf /vhost.conf
        fi
    else # Magento
        if [[ "${IS_MAGENTO_MULTI}" != "true" ]]; then # Magento single domain
            if [[ "${IS_HTTPS}" != "true" ]]; then  # Not use https
                cp -f /etc/nginx/vhost/magento.conf /vhost.conf
            else # Use https
                cp -f /etc/nginx/vhost/https/magento.conf /vhost.conf
            fi
        else # Magento multi domain
            if [[ "${IS_HTTPS}" != "true" ]]; then  # Not use https
                cp -f /etc/nginx/vhost/magento-multi.conf /vhost.conf
                sed -i "s/!MAGE_MODE!/${MAGENTO_MODE}/g" /vhost.conf
                sed -i "s/!MAGE_RUN_TYPE!/${MAGENTO_RUN_TYPE}/g" /vhost.conf
            else # Use https
                cp /etc/nginx/vhost/https/magento-multi.conf /vhost.conf
            fi
        fi
    fi

    if [[ -e /vhost.conf ]]; then
        temp=$(echo ${ROOT_FOLDER} | sed "s/\//\\\\\//g")
        sed -i "s/!SERVER_NAME!/${SERVER_NAME}/g" /vhost.conf
        sed -i "s/!ROOT_FOLDER!/${temp}/g" /vhost.conf
        mv /vhost.conf /etc/nginx/conf.d/vhost.conf
    fi
fi

sed -i "s/!PHP_SERVICE!/${PHP_SERVICE}/g" /etc/nginx/conf.d/php.conf
sed -i "s/!PHP_PORT!/${PHP_PORT}/g" /etc/nginx/conf.d/php.conf

# Update nginx config
if [[ ! -z "${NGINX_CONFIG}" ]]; then
	NGINX_CONFIG=($(echo ${NGINX_CONFIG} | tr ',' "\n"))
	for item in ${NGINX_CONFIG}
	do
	    item=($(echo ${NGINX_CONFIG} | tr '=' "\n"))
	    configName=$(echo "${item[0]}" | tr '[:upper:]' '[:lower:]')
	    configValue=${item[1]}

	    sed -i "/${configName}/d" /etc/nginx/conf.d/zz-docker.conf
		echo "${configName} = ${configValue}" >> /etc/nginx/conf.d/zz-docker.conf
	done
fi

nginx -t

exec "$@"