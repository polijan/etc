#!/bin/sh

# Change working dir in shell to last dir in lf on exit
# see: https://raw.githubusercontent.com/gokcehan/lf/master/etc/lfcd.sh

# You may also like to assign a key to this command:
#
#     bind '"\C-o":"lfcd\C-m"'  # bash
#     bindkey -s '^o' 'lfcd\n'  # zsh

lfcd() {
   local tmp dir
   tmp=$(mktemp)
   lf -last-dir-path="$tmp" "$@"
   [ -f "$tmp" ] || return
   dir=$(cat "$tmp")
   rm -f "$tmp"
   [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
}
