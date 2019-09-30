#!/bin/sh

export PAGER=less

export LESS=-MR#2
# default options for less:
# -M   long prompt
# -R   keep ANSI colors
# -#2  smooth horizontal scrolling

# doesn't display on alternate screen and quit away if text fits on one screen
alias less-FX='less -FX'

alias cat='cat+'


########################################################################

# The LESS_TERMCAP_* variables can be set in the environment or in the
# .lesskey file. It provides less(1) with alternative values for
# Terminal capabilities. When Less wants to use a terminal capability,
# say switch to bold, it first checks if there is a LESS_TERMCAP_md
# variable. If this variable exists, Less uses its value as the escape
# sequence to switch to bold. If not, it uses the value from the
# Termcap database. This mechanism allows the user to override Termcap
# database settings for Less.

# man(1) sends less(1) text with some very simple formatting that can
# only express bold and italics. In addition, less(1) uses various
# formatting capabilities for its internal use, such as to highlight
# search results and to display the mode line at the bottom. Here are
# some of the escape sequences that less uses(1) (I only list
# capabilities that it is reasonably useful to remap):
#
# termcap|terminfo| description
# -------+--------+-----------------------------------
#   ks   |  smkx  | make the keypad send commands
#   ke   |  rmkx  | make the keypad send digits
#   vb   |  flash | emit visual bell
#   mb   |  blink | start blink
#   md   |  bold  | start bold
#   me   |  sgr0  | turn off bold, blink and underline
#   so   |  smso  | start standout (reverse video)
#   se   |  rmso  | stop standout
#   us   |  smul  | start underline
#   ue   |  rmul  | stop underline

if [ -n "$BASH_VERSION" ]; then
   # with bash, we can avoid spawing external processes...
   export LESS_TERMCAP_mb=$'\E[01;33m'
   export LESS_TERMCAP_md=$'\E[01;31m'
   export LESS_TERMCAP_so=$'\E[01;44;33m'
   export LESS_TERMCAP_us=$'\E[01;32m'
   export LESS_TERMCAP_me=$'\E[0m'
   export LESS_TERMCAP_se=$'\E[0m'
   export LESS_TERMCAP_ue=$'\E[0m'
else
   LESS_TERMCAP_mb=$(printf '\033[1;33m')    ; export LESS_TERMCAP_mb
   LESS_TERMCAP_md=$(printf '\033[1;31m')    ; export LESS_TERMCAP_md
   LESS_TERMCAP_so=$(printf '\033[1;44;33m') ; export LESS_TERMCAP_so
   LESS_TERMCAP_us=$(printf '\033[1;32m')    ; export LESS_TERMCAP_us
   LESS_TERMCAP_me=$(printf '\033[0m')       ; export LESS_TERMCAP_me
   LESS_TERMCAP_se=$LESS_TERMCAP_me          ; export LESS_TERMCAP_se
   LESS_TERMCAP_ue=$LESS_TERMCAP_me          ; export LESS_TERMCAP_ue
fi


########################################################################

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
exists lesspipe && eval "$(lesspipe)"
