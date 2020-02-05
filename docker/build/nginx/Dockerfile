ARG VERSION

FROM nginx:$VERSION

MAINTAINER VoThanh Phong <nddang196@gmail.com>

ENV PHP_SERVICE php
ENV PHP_PORT 9000
ENV IS_HTTPS false
ENV IS_MAGENTO false
ENV IS_MAGENTO_MULTI false
ENV MAGENTO_MODE production
ENV MAGENTO_RUN_TYPE store
ENV ROOT_FOLDER /project

COPY ./vhost /etc/nginx/vhost/
COPY ./ssl /etc/nginx/ssl/
COPY ./include /etc/nginx/include/
COPY ./config/*.conf /etc/nginx/conf.d/
COPY ./entrypoint.sh /

RUN sed -i -e 's/\r$//' /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

VOLUME /etc/nginx/conf.d
VOLUME /etc/nginx/include

EXPOSE 80 443

WORKDIR ${ROOT_FOLDER}

CMD ["nginx", "-g", "daemon off;"]