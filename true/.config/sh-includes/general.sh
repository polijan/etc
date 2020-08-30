#!/bin/sh

alias ls='ls+'
alias cal='cal+'
alias diff='diff+'

alias rm='rm -i'

if command -v mv+ >/dev/null
   then alias mv='mv+'
   else alias mv='mv -i'
fi

if command -v cp+ >/dev/null
   then alias cp='cp+'
   else alias cp='cp -i'
fi


# ALWAYS ONLY DO SYMLINKS
alias ln='ln -s'
# add too: -i option from coreutils ???
