ARG BUILD_FROM=ghcr.io/hassio-addons/base:12.2.4
FROM ${BUILD_FROM}

ARG APACHE_VER=2.4.54-r0
ARG PHP_VER=8.1.11-r0

RUN wget -O /tmp/monica-v3.7.0.tar.bz2 https://github.com/monicahq/monica/releases/download/v3.7.0/monica-v3.7.0.tar.bz2

# The build breaks if we specify a version for php81-redis
RUN \
    apk update \
    && apk add --no-cache \
    apache2=${APACHE_VER} \
    apache2-ssl=${APACHE_VER} \
    php81=${PHP_VER} \
    php81-apache2=${PHP_VER} \
    php81-bcmath=${PHP_VER} \
    php81-curl=${PHP_VER} \
    php81-dom=${PHP_VER} \
    php81-fileinfo=${PHP_VER} \
    php81-gd=${PHP_VER} \
    php81-gmp=${PHP_VER} \
    php81-iconv=${PHP_VER} \
    php81-intl=${PHP_VER} \
    php81-mbstring=${PHP_VER} \
    php81-mysqli=${PHP_VER} \
    php81-opcache=${PHP_VER} \
    php81-openssl=${PHP_VER} \
    php81-pdo_mysql=${PHP_VER} \
    php81-phar=${PHP_VER} \
    php81-redis \
    php81-simplexml=${PHP_VER} \
    php81-sodium=${PHP_VER} \
    php81-tokenizer=${PHP_VER} \
    php81-xml=${PHP_VER} \
    php81-xmlreader=${PHP_VER} \
    php81-xmlwriter=${PHP_VER} \
    php81-zip=${PHP_VER} \
    mariadb-client=10.6.10-r0 \
    \
    && ln -s /usr/bin/php81 /usr/bin/php \
    \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin/ --filename=composer \
    && php -r "unlink('composer-setup.php');" \
    \
    && mkdir -p /var/www/monica \
    && tar jxf /tmp/monica-v3.7.0.tar.bz2 --strip-components=1 -C /var/www/monica/ \
    && composer install --no-interaction --no-dev --working-dir=/var/www/monica \
    \
    && sed -i 's@^#LoadModule rewrite_module modules/mod_rewrite\.so@LoadModule rewrite_module modules/mod_rewrite.so@' /etc/apache2/httpd.conf \
    && sed -i 's@^ErrorLog logs/error.log@ErrorLog /dev/stderr@' /etc/apache2/httpd.conf \
    && sed -i 's@^    CustomLog logs/access.log combined@    #CustomLog logs/access.log combined@' /etc/apache2/httpd.conf \
    \
    && rm -fr /tmp/*

COPY rootfs /

# Ensure correct permissions and move storage to /data
RUN \
    chmod 0750 /etc/cont-init.d/* \
    && chmod 0750 -R /etc/services.d/* \
    && chown -R apache:apache /var/www/monica

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Mark Weaver <mark@weavers.me>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Add-ons" \
    org.opencontainers.image.authors="Mark Weaver <mark@weavers.me>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/mww/hassio-addons" \
    org.opencontainers.image.documentation="https://github.com/mww/hassio-addons" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}