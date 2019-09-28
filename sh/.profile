#!/bin/sh

################################################################################
# This file ~/.profile is my shell startup file which is executed both by sh
# and bash(1) when they are launched as login shell !!!
################################################################################


################################################################################
# Startup files executed by the shell:
#
#--- BASH --------------------------------------------------------------
#
# bash as login shell:
#   1. /etc/profile (script typically source etc/bash.bashrc
#                    and then scripts in /etc/profile.d)
#   2. then: ~/.bash_profile or ~/.bash_login or ~/.profile
#            (typically this script would then source ~/.bashrc)
#
# bash as non-login interactive shell:
#   1. /etc/bash.bashrc
#   2. ~/.bashrc
#
# bash as non-login non-interactive shell:
#   1. content of $BASH_ENV
#
#
#--- SH  ---------------------------------------------------------------
#
# sh as login shell:
#   1. /etc/profile
#   2. ~/.profile
#
# sh as non-login interactive shell:
#   1. $ENV variable
#
# sh as non-login non-interactive shell:
#    none
#
#
# note: when invoked as sh, bash enters POSIX mode
# *after* startup files are read (unless --posix flag)
#
#-----------------------------------------------------------------------
#
# SO WHAT WE SHOULD DO:
# so we stay compatible by sh at a maximum and do extra for bash:
#
# 1) - have a "~/.profile"
#    - write it in in posix sh style and in it:
#       - setup variable ENV (maybe ~/.shrc)
#       - source the file pointed to by ENV
#       - source ~/.bashrc if we run bash
#    - make sure to NOT have ~/.bash_profile or ~/.bash_login
#      (otherwise bash won't read our .profile file)
#
# 2) write most in in POSIX-style in the file pointed to by "$ENV"
#
# 3) write bash-specific stuff in "~/.bashrc"
#
################################################################################


[ -n "$DEBUG_SH" ] && printf 'DEBUG (~/.profile): this is ~/.profile\n' >&2

# when starting a non-login interactive shell, sh
# will execute file contained in the ENV variable
export ENV="$HOME/.shrc"

# include sh config file pointed to by $ENV
# (since it's othwerwise only for non-login interactive sh (not bash) shells)
if [ -n "$ENV" ] && [ -f "$ENV" ]; then
   [ -n "$DEBUG_SH" ] && printf 'DEBUG (~/.profile): including $ENV (%s)\n' "$ENV" >&2
   . "$ENV"
fi

# if running bash, include .bashrc (if it exists)
# (since it's otherwise only for non-login interactive shells)
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
   [ -n "$DEBUG_SH" ] && printf 'DEBUG (~/.profile): including ~/.bashrc\n' >&2
   . "$HOME/.bashrc"
fi
