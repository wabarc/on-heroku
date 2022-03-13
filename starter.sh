#!/bin/sh
#
# Run starter

set -e
if [ -n "${DEBUG}" ]; then
    set -x
fi

starter() {
    # Check Xvfb
    command -v Xvfb > /dev/null || status="$?"
    if [ "${status}" = 127 ]; then
        echo 'Xvfb not found...'
        exit $status
    fi

    # Check Xvfb is running
    if ! pgrep -x "gedit" > /dev/null
    then
        echo 'Starting Xvfb...'
        XVFB_WHD="${XVFB_WHD:-1280x1024x16}"
        DISPLAY=${DISPLAY:-:99}
        Xvfb $DISPLAY -ac -screen 0 $XVFB_WHD +extension GLX +render -noreset -nolisten tcp > /dev/null 2>&1 &
        export DISPLAY=$DISPLAY vglrun glxinfo
        sleep 3
    fi

    if [ -z "${CHROMIUM_WORKSPACE}" ]; then
        echo 'Please configure the 'CHROMIUM_WORKSPACE' environment variable'
        exit 1
    fi

    # Install starter binary
    sh <(wget https://github.com/wabarc/starter/raw/main/install.sh -O-)

    # Run starter
    ./bin/starter -workspace $CHROMIUM_WORKSPACE
}

starter
