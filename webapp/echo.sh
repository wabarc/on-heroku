#!/usr/bin/dumb-init /bin/sh
#
# Forward HTTP requests to Tor Hidden Service

set -eu pipefail

#PORT="${PORT:=80}"
echo "PORT: ${PORT}"

#TOR_HOST="${TOR_HOST:=wizmoki7pm5r2bco4holq467cq53kicttzge47fmxtis4x6tpt2u4nqd.onion:80}"
echo "TOR_HOST: ${TOR_HOST}"

# Waiting for Tor startup
#sleep 3

#socat TCP-LISTEN:$PORT,reuseaddr,fork SOCKS4A:localhost:$TOR_HOST,socksport=9050
