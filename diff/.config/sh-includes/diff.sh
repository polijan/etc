#!/bin/sh

# colorizing diff if possible
if [ "$SYSTEM" = 'GNU' ]; then
   alias diff='diff --color'
elif exists colordiff; then
   diff() {
      if [ -t 1 ]
         then colordiff "$@"
         else command diff "$@"
      fi
   }
fi
