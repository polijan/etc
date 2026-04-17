#!/bin/sh

# Provides functions to the poorman-* utilities
# - Include the "common" function library
# - Define the poorman_try function (see below)

. ~/.local/lib/sh/common.sh


# Usage: poorman_try COMMAND [ARGUMENTS]...
# *Tries* to exec the command with its arguments
#
# 1. executes directly if possible,
# 2. or via busybox if installed and the command exists as an applet
# 3. or via toybox  if installed and the command exists as an applet
# 4. if this function returns, than we do not know how to execute it,
#    (thus an altenate implementaion needs to be provided)
poorman_try() {
   if exists "$1"; then
      exec "$@"
   elif exists busybox && busybox --list | grep -q "^${1}$"; then
      exec busybox "$@"
   elif exists toybox  && toybox | tr ' ' '\n' | grep -q "^${1}$"; then
      exec toybox "$@"
   fi
}
