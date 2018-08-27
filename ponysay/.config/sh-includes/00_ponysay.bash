#!/bin/sh

# EYE-CANDY: we execute ponysay to put a pony in the terminal
#            (every time we start an interactive shell)
#
# let's name this script so that's it's included early-on...
# so that if my shell rc file takes a few second to load, then it
# still feels ok because I can anyway stare at the awesome pony :)

# if we're using the linux console, or if terminal is small,
# there are better things to do than watching 'cute' ponies.
if [ "$TERM" != linux ] && [ $COLUMNS -ge 72 ] && [ $LINES -ge 24 ]; then
   if [ $LINES -ge 35 ]
      then ponysay -b unicode -q
      else ponysay -o # only the graphics, no quote
   fi
fi
