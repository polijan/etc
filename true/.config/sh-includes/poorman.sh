#!/bin/sh

# Create shell aliases for the poorman-* programs (from ~/.local/bin)
# when the commands they mimic are not available.
if cd ~/.local/bin; then
   for i in poorman-*; do
       [ -f "$i" ] || break
       command -v "${i#poorman-}" >/dev/null || alias "${i#poorman-}"="$i"
   done
   cd - >/dev/null
   unset i
fi
