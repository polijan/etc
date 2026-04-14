#!/bin/sh
toybox() {
   if [ $# -eq 0 ] && [ -t 1 ] && exists toybox
      then tui-toybox
      else command toybox "$@"
   fi
}
