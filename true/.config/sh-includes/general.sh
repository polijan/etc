#!/bin/sh

alias l='ls+'
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

# GNU and BSD utility understand --color
# busybox may not implement the option, but seems to understand it.
alias grep='grep --color'

# ALWAYS ONLY DO SYMLINKS (use \ln to override)
alias ln='ln -s'
# add too: -i option from coreutils ???

# man: by setting this variable, man format it ouput with a given line width.
# (perhaps we should avoid hardcoding it and make a `man` wrapper that sets
#  MANWDITH only when terminal size is larger than that.)
export MANWIDTH=74
