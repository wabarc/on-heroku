FROM ghcr.io/wabarc/wayback:latest

LABEL maintainer "Wayback Archiver <wabarc@tuta.io>"

ENV BASE_DIR /wayback

COPY supervisord.conf /etc/
COPY entrypoint.sh /

# Install packages
RUN set -x \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" > /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    \
    && apk update \
    && apk add --no-cache dbus dumb-init libstdc++ nss chromium harfbuzz nss freetype ttf-freefont font-noto-emoji font-noto-cjk \
    && apk add --no-cache ca-certificates supervisor curl \
    \
    ## Clean
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN chmod +x /entrypoint.sh
RUN rm -rf /var/cache/apk/*

#USER tor
WORKDIR ${BASE_DIR}

CMD /usr/bin/supervisord
