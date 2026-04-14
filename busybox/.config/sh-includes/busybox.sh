#!/bin/sh
busybox() {
   if [ $# -eq 0 ] && [ -t 1 ] && exists fzf
      then tui-busybox
      else command busybox "$@"
   fi
}
