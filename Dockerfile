FROM ghcr.io/wabarc/wayback:latest

LABEL maintainer "Wayback Archiver <wabarc@tuta.io>"

COPY supervisord.conf /etc/
COPY entrypoint.sh /

RUN apk update && apk add ca-certificates supervisor curl
RUN chmod +x /entrypoint.sh
RUN rm -rf /var/cache/apk/*

USER tor
WORKDIR /

CMD /usr/bin/supervisord
