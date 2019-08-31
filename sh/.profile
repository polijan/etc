#!/bin/sh

################################################################################
# This file ~/.profile is my shell startup file which is executed both by sh
# and bash(1).
#
# Note that this file is not read by bash(1), if ~/.bash_profile or
# ~/.bash_login exists. Thus I should not have those.
#
# ~/.profile is written in posix-only mode, so it's compatible with sh(!) and
# bash(1)... then if we run bash(1), we then source ~/.bashrc which should
# contain bash-only stuff
################################################################################


# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi


