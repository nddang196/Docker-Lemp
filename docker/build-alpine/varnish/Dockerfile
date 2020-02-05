FROM alpine

MAINTAINER VooThanh DEV <voothanhphong@gmail.com>

ENV VCL_CONFIG_PATH /etc/varnish/default.vcl
ENV CACHE_SIZE      64M
ENV BACKEND_HOST    0.0.0.0
ENV BACKEND_PORT    80
ENV VARNISH_HOST    ''
ENV VARNISH_PORT    8080
ENV VARNISH_PARAMS -p default_ttl=3600 -p default_grace=3600

ADD start.sh /start.sh
RUN apk add --update varnish && \
    sed -i -e 's/\r$//' /start.sh && \
    chmod +x /start.sh && \
    rm -rf /var/cache/apk/*

WORKDIR /etc/varnish

EXPOSE 80 8080

CMD ["/start.sh"]