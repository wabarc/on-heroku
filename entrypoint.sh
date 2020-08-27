#!/bin/sh
#
# Perform wayback
set -eu pipefail

# check dependency
command -v wayback > /dev/null || { echo "wayback is not installed in this system" 1>&2; exit 1; }
printenv WAYBACK_ARGS > /dev/null || { echo "environment variable WAYBACK_ARGS is not found in this system" 1>&2; exit 1; }

# execute wayback command
# more args see: https://github.com/wabarc/wayback#usage
wayback $WAYBACK_ARGS

