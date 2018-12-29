#!/bin/sh

# colorizing diff on the terminal when possible
if is-gnu diff; then
   alias diff='diff --color=auto'
elif exists colordiff; then
   diff() {
      if [ -t 1 ]
         then colordiff "$@"
         else command diff "$@"
      fi
   }
fi
