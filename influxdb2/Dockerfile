ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base/amd64:6.0.0
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base system
ARG BUILD_ARCH=amd64

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        wget \
        gnupg=2.2.27-2 \
        lsb-release=11.1.0 \
    && wget -qO- https://repos.influxdata.com/influxdb.key | gpg --dearmor | \
        tee /etc/apt/trusted.gpg.d/influxdb.gpg > /dev/null \
    && export DISTRIB_ID=$(lsb_release -si); export DISTRIB_CODENAME=$(lsb_release -sc) \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/influxdb.gpg] https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | \
        tee /etc/apt/sources.list.d/influxdb.list > /dev/null \
    && apt-get update && apt-get install -y --no-install-recommends \
        influxdb2=2.2.0 \
    && rm -fr \
        /tmp/* \
        /var/{cache,log}/* \
        /var/lib/apt/lists/*

COPY rootfs /

EXPOSE 8086
