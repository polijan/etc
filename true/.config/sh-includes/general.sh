#!/bin/sh

alias ls='ls+'
alias cal='cal+'

alias cp='cp -i'
alias rm='rm -i'

if command -v mv+ >/dev/null
   then alias mv='mv+'
   else alias mv='mv -i'
fi
