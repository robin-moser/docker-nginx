# ++++++++++++++++++++++++++++++++++++++
# Dockerfile: robinmoser/nginx
# ++++++++++++++++++++++++++++++++++++++

FROM alpine:edge
LABEL maintainer="Robin Moser"

ARG S6_VERSION="2.1.0.2"
ARG S6_ARCH="amd64"

# default ENV variables
ENV \
    TIMEZONE="Europe/Berlin" \
    NGINX_INDEX="index.html" \
    NGINX_WEB_ROOT="/app/src"

RUN apk add --no-cache \
        ca-certificates \
        curl \
        tzdata \
        nginx

# delete default config files
RUN rm -rf /etc/nginx/http.d

# Install s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-${S6_ARCH}.tar.gz /tmp/
RUN tar --directory / --extract --file /tmp/s6-overlay-${S6_ARCH}.tar.gz \
    && rm -rf /tmp/s6-overlay-${S6_ARCH}.tar.gz

# copy S6 service config
COPY resources/services.d/ /etc/services.d

# copy S6 init scipts
COPY resources/entrypoint.d/ /etc/cont-init.d

# copy nginx config
COPY config/nginx/ /etc/nginx/

# docker healthcheck
HEALTHCHECK --timeout=2s --interval=10s --start-period=5m --retries=3 \
    CMD curl --silent --fail http://localhost/ping -H 'Host: healthcheck.local'

ENTRYPOINT ["/init"]
