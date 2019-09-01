#!/bin/bash
# ~/.bash_logout: executed by bash(1) when login shell exits.

if [ -n "$DEBUG_SH" ]; then
   printf 'DEBUG (~/.bash_logout): this is ~/.bash_logout\n'
elif [ "$SHLVL" = 1 ]; then
   # when leaving the console clear the screen to increase privacy
   clear
   [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
