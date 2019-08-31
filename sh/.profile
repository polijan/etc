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
EDITOR=$(loopfind exists nano+ nano pico e3pi emacs ne mg e3em vim vi)
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

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
