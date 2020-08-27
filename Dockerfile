############################
# STEP 1 build executable binary
############################
FROM golang:1.14-alpine AS builder
RUN apk update && apk add --no-cache build-base ca-certificates git
RUN git clone https://github.com/wabarc/wayback.git /tmp/wayback
RUN cd /tmp/wayback && make linux-amd64 && mv ./bin/wayback-linux-amd64 /wayback

############################
# STEP 2 build a small image
############################
FROM alpine:3.12

RUN apk update && apk add ca-certificates supervisor curl tor
RUN mv /etc/tor/torrc.sample /etc/tor/torrc
RUN echo 'ExcludeNodes {cn},{hk},{mo},{kp},{ir},{sy},{pk},{cu},{vn},{ru}' >> /etc/tor/torrc
RUN echo 'ExcludeExitNodes {cn},{hk},{mo},{sg},{th},{pk},{by},{ru},{ir},{vn},{ph},{my},{cu}' >> /etc/tor/torrc
RUN echo 'StrictNodes 1' >> /etc/tor/torrc

LABEL maintainer "WaybackBot <wabarc@tuta.io>"
COPY --from=builder /wayback /usr/local/bin
COPY supervisord.conf /etc/supervisord.conf
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

RUN rm -rf /var/cache/apk/*

USER tor
WORKDIR /

CMD /usr/bin/supervisord
