ARG VERSION

FROM nginx:alpine

MAINTAINER VooThanh DEV <voothanhphong@gmail.com>

ENV SERVER_NAME docker.io
ENV PHP_SERVICE php
ENV PHP_PORT 9000
ENV IS_HTTPS false
ENV IS_MAGENTO false
ENV IS_MAGENTO_MULTI false
ENV MAGENTO_MODE production
ENV MAGENTO_RUN_TYPE store
ENV ROOT_FOLDER /project

COPY vhost/ /etc/nginx/vhost/
COPY ssl/ /etc/nginx/ssl/
COPY include/ /etc/nginx/include/
COPY config/*.conf /etc/nginx/conf.d/

COPY entrypoint.sh /

RUN apk update && \
    apk add bash && \
    mkdir -p ${ROOT_FOLDER} && \
    sed -i -e 's/\r$//' /entrypoint.sh && \
    chmod +x /entrypoint.sh && \
    rm -rf /var/cache/apk/*

WORKDIR ${ROOT_FOLDER}

ENTRYPOINT ["/entrypoint.sh"]

VOLUME /etc/nginx/conf.d
VOLUME /etc/nginx/include

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]