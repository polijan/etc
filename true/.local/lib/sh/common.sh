#!/bin/sh

# Library of very common functions:
# - Only very common functions used in many scripts,
# - Only use portable POSIX utilities.
#
# To include the library:
# . ~/.local/lib/sh/common.sh


# Usage: exists COMMAND
# Return 0 iff the command is found
exists() { command -v "$@" >/dev/null; }

# Usage: die [-NUMBER] [--] [MESSAGE]...
# * Print the basename of the program,
# * Print the error message (or "Abort" if message is missing or empty)
# * Exit the program with the given error (or by default 1)
die() {
   # As this function is `exit`-ing and not returning, global variables can be
   # used without fear of polluting the environment
   DIE_EXIT_CODE=1
   DIE_START=''
   DIE_END=''

   case $1 in
               --) shift ;;
      -|-*[!0-9]*) ;; # not a number
                *) DIE_EXIT_CODE=${1#-}; shift;;
   esac

   [ -n "$*" ] || set -- 'Abort...'

   if [ -t 2 ]; then
      DIE_START='\033[1;38;5;9m'
      DIE_END='\033[0m'
   fi
   printf '%b%s%b: %s\n' "$DIE_START" "$(basename "$0")" "$DIE_END" "$*" >&2

   exit "$DIE_EXIT_CODE"
}

# Usage: requires COMMAND
# Exits the program (with err code 6) iff the command is not found
requires() { exists "$@" || die -6 "requires command $*"; }


# Usage: usage [DO_NOT_ABORT]...
# - Scan the program source for a 'comment block' starting with "Usage:",
# - Display the whole content of that block
# - While displaying the string $0 is replaced with the program (base)name,
# - Options:
#   * no args => print usage on standard error + EXIT the program (err code 2)
#   * any arg => print usage on standard input and does not exit
usage() {
   case $# in
      0) usage - >&2
         exit 2 ;;

      *) awk -v PROG_NAME="$(basename "$0")" '
             /^# Usage:/ { p=1 }
             /^#/        { if (p) {
                              sub("^# ?", "");
                              sub(/\$\<0\>/, PROG_NAME);
                              print; next;
                         } }
                         { if (p) exit }
             ' "$0" ;;
   esac
}
