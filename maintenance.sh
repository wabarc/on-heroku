#!/bin/sh
#
# Auto enable or disable Heroku maintenance mode
# vim: set et ts=2 sw=2
set -e

ver='v12.18.3'
node="node-${ver}-linux-x64"
loc="/tmp/${node}.tar.xz"

usage() {
  cat <<EOF
Usage: sh maintenance.sh [options]

Options:
    -a, --app <heroku app name>
    -h, --help Usage
    -k  --api-key <heroku authorization token>
        Heroku authorization token, create an new token:
        https://dashboard.heroku.com/account/applications/authorizations/new
    -m, --mode <maintenance mode>
        Maintenance mode for heroku app, options: on, off (Default: on)
EOF
  exit 1
}

get_args() {
  mode='on'

  while [ "$#" -gt 0 ]; do
    case "${1}" in
    --help | -h)
      usage 0
      ;;
    --mode | -m)
      mode="${2}"
      shift
      ;;
    --app | -a)
      app_name="${2}"
      shift
      ;;
    --api-key | -k)
      api_key="${2}"
      shift
      ;;
    *)
      echo "Invalid argument: ${1}"
      usage 1
      ;;
    esac
    shift 1
  done
}

prepare() {
  arch="$(arch)"
  if [ -z "${arch##X86_64}" ]; then
    err "Unsupport arch..."
    exit 1
  fi
  i='0'
  os="$(cat </etc/os-release | grep 'NAME=' | sed 's/.*\"\(.*\)\".*/\1/g')"
  if [ -z "${os##*Debian*}" ] || [ -z "${os##*Ubuntu*}" ]; then
    i='1'
    apt-get update -y && apt-get install -y --no-install-recommends wget xz-utils ca-certificates
  elif [ -z "${os##*Fedora*}" ] || [ -z "${os##*CentOS*}" ]; then
    i='1'
    yum update -y && yum install -y xz wget ca-certificates
  elif [ -z "${os##*Alpine*}" ]; then
    apk update && apk add wget ca-certificates nodejs
    i='1'
  else
    err "Unsupport OS"
    exit 1
  fi
  if [ "${i}" = "1" ]; then
    echo "Downloading the Node.js pre-built installer"
    wget "https://nodejs.org/dist/v12.18.3/${node}.tar.xz" -O "${loc}"
    if [ -f "${loc}" ]; then
      tar -xJf "${loc}" -C /tmp
      PATH="${PATH}:/tmp/${node}/bin"
    else
      err "Download Node.js failure..."
      exit 1
    fi
    if [ -z "$(command -v heroku)" ]; then
      npm i -g heroku
    fi
  else
    err "Requirement missing..."
    exit 1
  fi
}

maintenance() {
  if [ "${mode}" = "on" ]; then
    HEROKU_API_KEY="${api_key}" heroku maintenance:on -a "${app_name}"
    HEROKU_API_KEY="${api_key}" heroku ps:scale web=0 -a "${app_name}"
  fi
  if [ "${mode}" = "off" ]; then
    HEROKU_API_KEY="${api_key}" heroku maintenance:off -a "${app_name}"
    HEROKU_API_KEY="${api_key}" heroku ps:scale web=1 -a "${app_name}"
  fi
}

main() {
  if [ -z "${1}" ]; then
    usage 0
  else
    get_args "$@"
    prepare
    maintenance
  fi
}

main "$@"

