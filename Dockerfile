# ++++++++++++++++++++++++++++++++++++++
# Dockerfile: robinmoser/nginx
# ++++++++++++++++++++++++++++++++++++++

ARG ALPN_VERSION="3.19"
ARG S6_VERSION="3.1.6.2"
ARG S6_ARCH="x86_64"

FROM alpine:$ALPN_VERSION
LABEL maintainer="Robin Moser"

ARG S6_VERSION
ARG S6_ARCH

# default ENV variables
ENV \
    TZ="Europe/Berlin" \
    NGINX_INDEX="index.html" \
    NGINX_WEB_ROOT="/app/src" \
    S6_KEEP_ENV=1

RUN apk add --no-cache \
    ca-certificates \
    curl \
    tzdata \
    nginx

# add the application user
RUN addgroup -g 1000 application \
    && adduser -u 1000 -G application -DH application \
    && chown application:application /var/lib/nginx \
    && chown -R application:application /var/lib/nginx/tmp

# delete default config files
RUN rm -rf /etc/nginx/http.d

# Install s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/\
v${S6_VERSION}/s6-overlay-noarch.tar.xz /tmp/

RUN tar --directory / --extract --file /tmp/s6-overlay-noarch.tar.xz \
    && rm -rf /tmp/s6-overlay-noarch.tar.xz

ADD https://github.com/just-containers/s6-overlay/releases/download/\
v${S6_VERSION}/s6-overlay-${S6_ARCH}.tar.xz /tmp/

RUN tar --directory / --extract --file /tmp/s6-overlay-${S6_ARCH}.tar.xz \
    && rm -rf /tmp/s6-overlay-${S6_ARCH}.tar.xz

# copy S6 config and scripts
COPY resources/services.d/ /etc/s6-overlay/s6-rc.d/
COPY resources/entrypoint.d/ /etc/cont-init.d

# copy nginx config
COPY config/nginx/ /etc/nginx/

# Preparing the environment
WORKDIR ${NGINX_WEB_ROOT}

# docker healthcheck
HEALTHCHECK --timeout=2s --interval=10s --start-period=5m --retries=3 \
    CMD curl --silent --fail http://localhost/ping -H 'Host: healthcheck.local'

ENTRYPOINT ["/init"]
