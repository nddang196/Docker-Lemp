#!/bin/bash

set -e

mkdir -p ${ROOT_FOLDER}

convertMageMultiSite () {
    local result=''

    for item in $1
    do
        item=($(echo ${item} | tr '=' "\n"))
        if [[ "$result" != '' ]]; then
            result="$result\n"
        fi

        result="$result${item[0]}\t${item[1]};"
    done

    echo "$result"
}

getServerNameMageMultiSite () {
    local result=''

    for item in $1
    do
        item=($(echo ${item} | tr '=' "\n"))
        if [[ "$result" != '' ]]; then
            result="$result "
        fi

        result="$result${item[0]} www.${item[0]}"
    done

    echo "$result"
}

createVhostFile () {
    local server="$1 www.$1"
    local rootFolder=$2
    local isHttps=$3
    local isMage=$4
    local isMageMulti=$5
    local mageMode=$6
    local mageType=$7
    local mageSitesArr=($(echo $8 | tr ';' "\n"))
    local mageSites=''
    local fileTemp="/etc/nginx/conf.d/$1.conf"

    if [[ "$isMage" != "true" ]]; then # Not Magento
        if [[ "$isHttps" != "true" ]]; then # Not use https
            cp -f /etc/nginx/vhost/mysite.conf ${fileTemp}
        else # Use https
            cp -f /etc/nginx/vhost/https/mysite.conf ${fileTemp}
        fi
    else # Magento
        if [[ "$isMageMulti" != "true" ]]; then # Magento single domain
            if [[ "$isHttps" != "true" ]]; then  # Not use https
                cp -f /etc/nginx/vhost/magento.conf ${fileTemp}
            else # Use https
                cp -f /etc/nginx/vhost/https/magento.conf ${fileTemp}
            fi
        else # Magento multi domain
            if [[ "$isHttps" != "true" ]]; then  # Not use https
                cp -f /etc/nginx/vhost/magento-multi.conf ${fileTemp}
            else # Use https
                cp /etc/nginx/vhost/https/magento-multi.conf ${fileTemp}
            fi

            mageSites="$(convertMageMultiSite ${mageSitesArr[@]})"
            server="$(getServerNameMageMultiSite ${mageSitesArr[@]})"
            sed -i "s/!MAGE_MULTI_SITES!/$mageSites/g" ${fileTemp}
            sed -i "s/!MAGE_MODE!/$mageMode/g" ${fileTemp}
            sed -i "s/!MAGE_RUN_TYPE!/$mageType/g" ${fileTemp}
        fi
    fi

    if [[ -e ${fileTemp} ]]; then
        rootFolder=$(echo ${rootFolder} | sed "s/\//\\\\\//g")
        sed -i "s/!SERVER_NAME!/$server/g" ${fileTemp}
        sed -i "s/!ROOT_FOLDER!/$rootFolder/g" ${fileTemp}
    fi
}

# Config vhost from $SERVER_NAME
setupVhost () {
    if [[ ${SERVER_NAME} == '' ]]; then
        return;
    fi

    local serverNames=($(echo ${SERVER_NAME} | tr ',' "\n"))
    local rootFolders=($(echo ${ROOT_FOLDER} | tr ',' "\n"))
    local httpsServer=($(echo ${IS_HTTPS} | tr ',' "\n"))
    local projectsMagento=($(echo ${IS_MAGENTO} | tr ',' "\n"))
    local projectsMagentoMulti=($(echo ${IS_MAGENTO_MULTI} | tr ',' "\n"))
    local magentoModes=($(echo ${MAGENTO_MODE} | tr ',' "\n"))
    local magentoTypes=($(echo ${MAGENTO_RUN_TYPE} | tr ',' "\n"))
    local magentoSites=($(echo ${MAGENTO_MULTI_SITES} | tr ',' "\n"))
    local count=0

    for server in ${serverNames[@]}
    do
        if [[ -e /etc/nginx/conf.d/${server}.conf ]]; then
            continue
        fi

        local rootFolder=${rootFolders[$count]}
        local isHttps=${httpsServer[$count]} 
        local isMage=${projectsMagento[$count]}
        local isMageMulti=${projectsMagentoMulti[$count]}
        local mageMode=${magentoModes[$count]}
        local mageType=${magentoTypes[$count]}
        local mageSites=${magentoSites[$count]}

        createVhostFile ${server} ${rootFolder} ${isHttps} ${isMage} ${isMageMulti} ${mageMode} ${mageType} ${mageSites}
        count=$(expr ${count} + 1)
    done
}

setupVhost

# Config php
sed -i "s/!PHP_SERVICE!/$PHP_SERVICE/g" /etc/nginx/conf.d/php.conf
sed -i "s/!PHP_PORT!/$PHP_PORT/g" /etc/nginx/conf.d/php.conf

# Update nginx config
if [[ "${NGINX_CONFIG}" != '' ]]; then
	NGINX_CONFIG=($(echo ${NGINX_CONFIG} | tr ',' "\n"))
	for item in ${NGINX_CONFIG}
	do
	    item=($(echo ${item} | tr '=' "\n"))
	    configName=$(echo "${item[0]}" | tr '[:upper:]' '[:lower:]')
	    configValue=${item[1]}

	    sed -i "/${configName}/d" /etc/nginx/conf.d/zz-docker.conf
		echo "$configName = $configValue" >> /etc/nginx/conf.d/zz-docker.conf
	done
fi

nginx -t

exec "$@"
