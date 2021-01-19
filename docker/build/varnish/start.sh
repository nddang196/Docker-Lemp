#!/bin/sh

mkdir -p /var/lib/varnish/`hostname` && chown nobody /var/lib/varnish/`hostname`
if [[ -s "${VCL_CONFIG_PATH}" ]]; then
  varnishd -F -s malloc,${CACHE_SIZE} \
  -a ${VARNISH_HOST}:${VARNISH_PORT} \
  -f ${VCL_CONFIG_PATH} ${VARNISHD_PARAMS}
else
  varnishd -F -s malloc,${CACHE_SIZE} \
  -a ${VARNISH_HOST}:${VARNISH_PORT} \
  -b ${BACKEND_HOST}:${BACKEND_PORT} \
  ${VARNISH_PARAMS}
fi

sleep 1
varnishlog