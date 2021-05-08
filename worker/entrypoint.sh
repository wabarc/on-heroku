#!/bin/sh
#
# Perform wayback

# check dependency
command -v wayback > /dev/null || { echo "wayback is not installed in this system" 1>&2; exit 1; }
printenv WAYBACK_ARGS > /dev/null || { echo "environment variable WAYBACK_ARGS is not found in this system" 1>&2; exit 1; }

if [ -n "${WAYBACK_CONFIGURATIONS}" ]; then
    printenv WAYBACK_CONFIGURATIONS > wayback.conf
    WAYBACK_ARGS="$WAYBACK_ARGS -c wayback.conf"
fi

if [ -n "${WAYBACK_TOR_LOCAL_PORT}" ]; then
    export PORT=$WAYBACK_TOR_LOCAL_PORT
fi

if [ -z "${CHROMEDP_NO_SANDBOX}" ]; then
    export CHROMEDP_NO_SANDBOX=true
fi
if [ -z "${CHROMEDP_DISABLE_GPU}" ]; then
    export CHROMEDP_DISABLE_GPU=true
fi

# execute wayback command
# more args see: https://github.com/wabarc/wayback#usage
wayback $WAYBACK_ARGS

