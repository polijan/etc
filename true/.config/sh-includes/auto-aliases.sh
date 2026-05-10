#!/bin/sh

# Automatically create auto aliases (to certain programs in ~/.local/bin)

if cd ~/.local/bin; then

   # poorman-*: create an alias when the command they mimic is not available
   for i in poorman-*; do
       [ -f "$i" ] || break
       command -v "${i#poorman-}" >/dev/null || alias "${i#poorman-}"="$i"
   done

   # *+: create an alias when the command they wrap is available
   for i in *+; do
       [ -f "$i" ] || break
       command -v "${i%+}" >/dev/null && alias "${i%+}"="$i"
   done

   cd - >/dev/null
   unset i

fi
