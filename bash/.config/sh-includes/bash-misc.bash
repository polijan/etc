#!/bin/bash
#^--- not to be executed directly, this is just for editors' syntax hilighting


################################################################################
# OPTIONS
################################################################################

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar


################################################################################
# HISTORY
################################################################################

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# history length
# HISTSIZE    : max number of commands that will be displayed
# HISTFILESIZE: how many commands are retained in ~/.bash_history
# HISTIGNORE  : commands not to be added to ~/.bash_history
export HISTSIZE=1000
export HISTFILESIZE=9999
export HISTIGNORE="history:exit"

# show the most used commands
alias history-often="history | awk '{print $2}' | sort | uniq -c | sort -rn | head"

################################################################################
# BASH COMPLETION
################################################################################

# enable programmable completion features (you don't need to enable this, if
# it's already enabled in /etc/bash.bashrc and /etc/profile sources
# /etc/bash.bashrc).
if ! shopt -oq posix; then
   if [ -f /usr/share/bash-completion/bash_completion ]; then
      . /usr/share/bash-completion/bash_completion
   elif [ -f /etc/bash_completion ]; then
      . /etc/bash_completion
   fi
fi
