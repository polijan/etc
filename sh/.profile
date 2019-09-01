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
ENV=$HOME/.shrc
# so I think of it as equivalent to ~/.bashrc but for sh
# I will also include it from here (near the end of this file)



# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022



# usage: exists COMMAND
# return 0 if command is found or failure if command isn't found
# prefers this than which(1) since it also detects function, aliases, ...
exists() { command -v "$@" > /dev/null ; }

# loopfind COMMAND [ITEM]...
# iterate through the list of ITEMS and applies COMMAND to each argument;
# if the COMMAND is succesful, loopfind echoes that argument and stops.
# return value is 0 (if we can print an argument from the LIST)
# or 1 (if end of list is reached and COMMAND never was succesful)
#
# example: MP3_PLAYER=$(loopfind exists  mpv vlc mplayer mpg321 mpg123 ffplay) || exit 127
loopfind() {
   local i cmd
   cmd="$1"
   shift
   for i do
       $cmd "$i" >/dev/null && { printf '%s\n' "$i"; return; }
   done
   return 1
}

################################################################################
# configuration for ~/.local
# also see this post: http://nullprogram.com/blog/2017/06/19/
################################################################################

# PATH
PATH="$HOME/.local/bin:$PATH"
# Add directories to the include and link path for C and C++ compilers
# This is like the -I compiler option and the -L linker option, except
# there wont be a need to use them explicitly
export C_INCLUDE_PATH="$HOME/.local/include"
export CPLUS_INCLUDE_PATH="$HOME/.local/include"
export LIBRARY_PATH="$HOME/.local/lib"
export PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig"
# run time dynamic linker:
if [ -z "$LD_LIBRARY_PATH" ]
   # not sure why the IF is necessary, but termux gives me some errors otherwise
   then export LD_LIBRARY_PATH="$HOME/.local/lib"
   else export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/.local/lib"
fi
# man pages:
exists manpath || export MANPATH="$HOME/.local/share/man:$MANPATH"
  # I would expect that I had to do the following, but no,
  # it seems to seems to be able to figure it out
  # export MANPATH="$HOME/.local/share/man:$(manpath)"

################################################################################

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
   PATH="$HOME/bin:$PATH"
fi

# EDITOR
##EDITOR=$(loopfind exists nano+ nano pico e3pi emacs ne mg e3em vim vi)
##export EDITOR
##export VISUAL="$EDITOR"

for i in nano+ nano pico e3pi emacs ne mg e3em vim vi; do
    if command -v "$i" >/dev/null; then
       EDITOR=$i
       break
    fi
done
unset i
export EDITOR
export VISUAL="$EDITOR"


################################################################################
# INCLUDE *.sh AND *.bash FILES FROM ~/.config/sh-includes
################################################################################

#for i in "$HOME/.config/sh-includes"/*.{bash,sh}; do
#    . "$i"
#done
#unset i

################################################################################

# include sh config file pointed to by $ENV
# (since it's otherwise only for sh (not bash) and only non-login interactive shells)
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
