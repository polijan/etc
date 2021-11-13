#!/bin/sh

################################################################################
# This file ~/.profile is my shell startup file which is executed both by sh
# and bash(1) when they are launched as login shell !!!
################################################################################


################################################################################
# As a reminder, here are how shells are started:
################################################################################
#
#-- STARTUP FILES FOR SH  ------------------------------------------------------
#
# as a login shell:            as a non-login             as a non-login
# 1. /etc/profile              interactive shell:         non-interactive shell:
# 2. ~/.profile                1. file from the $ENV      (none)
#                                 variable
#
#--- STARTUP FILES FOR BASH ----------------------------------------------------
#
#                              as a non login             as a non-login
# as a login shell:            interactive shell:         non-interactive shell:
# 1. /etc/profile              1. /etc/bash.bashrc        1. file from $BASH_ENV
# 2. one of: ~/.bash_profile   2. ~/.bashrc
#      , or: ~/.bash_login                                (^) except for remote
#      , or: ~/.profile                                       shells, (check out
#                                                                   ~/.basrchrc)
# /etc/profile would typically be written to source
# /etc/bash.bashrc and scripts in /etc/profile.d
#
# add the local .profile or bash_profile/login does
# typically source ~/.bashrc
#
################################################################################
# Thus, here's our setup with the goal to
#
# - which allows to include the same things in an interactive shell whether
#   it is a login or non-login one
# - allow to keep a max of common definition for plain sh (dash?) and bash
#
# * a ~/.profile file that:
#   1. sets up ENV to ~/.shrc (in ~/.profile)
#   2. and includes ~/.shrc
#
# * a ~/.bashrc which mostly just source ~/.shrc
#
# * a ~/.shrc written in POSIX sh which include other sh script (and bash
#             scripts too if we run with bash) from ~/.config/sh-includes/
#
# here's how the startup works:
#
#               (set in ~/.profile)
# sh      -> $ENV  ===========>  ~/.shrc:  1> essential stuff (POSIX style)
#                                 ^i   ^   2> include ~/.config *.sh
#                                 |n   |   3> include ~/.config *.bash (if bash)
# sh -l   -> 1. /etc/profile      |c   |
#            2. ~/.profile -------|l   |i
#                                 |u   |n
# bash -l -> 1. /etc/profile      |d   |c
#            2. ~/.profile -------'e   |l
#                                      |u
# bash    -> 1. /etc/bash.bashrc       |d
#            2. ~/bashrc --------------'e
#
################################################################################



[ -n "$DEBUG_SH" ] && printf 'DEBUG (~/.profile): this is ~/.profile\n' >&2

# set up ENV
# (so it will be in the environment to use when we start a non-login sh)
export ENV="$HOME/.shrc"

# then include it
if [ -f "$ENV" ]; then
   #output $END without expansion
   #shellcheck disable=SC2016
   [ -n "$DEBUG_SH" ] && printf 'DEBUG (~/.profile): including $ENV (%s)\n' "$ENV" >&2
   #shellcheck source=/dev/null
   . "$ENV"
fi
