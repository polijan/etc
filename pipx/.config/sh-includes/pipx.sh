#!/bin/sh

#############################################
# pipx - python application package manager #
#############################################

# As we have pipx, we don't need pip access from the shell
# (use full pip's complete path to override)
pip() {
   echo 'use pipx (or full path to pip) instead' >&2
   return 1
}

# bash "tab completions" for pipx
# to enable it, follow instructions printed by:
# $ pipx completions
[ -n "$BASH_VERSION" ] && eval "$(register-python-argcomplete pipx)"

