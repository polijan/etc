#!/bin/bash
################################################################################
# Using Ctags with Nano (and other editors)
# see: http://sassan.me.uk/blog/using-ctags-with-nano-and-other-editors/
#
# Ctags is a pretty useful utility to aid navigating source code. It creates a
# database of function/variable/type definitions within your code. Vi and Emacs
# support using a Ctags database, Nano (along with many other editors) does not.
# This script reads the database and finds the appropriate file and line to open
# the editor at (however Nano seems to lack any sort of plugin interface, adding
# support for finding a tag highlighted within the editor is not possible here)
#
################################################################################
#
# USAGE:
#
# Firstly you'll need to create the ctags database. Running "ctags -R" in your
# source directory should do the trick. For more advanced options to ctags, read
# the manual.
#
# Now you may run "nanoctags.sh <sometag>" to open nano at the point where it is
# defined.
#
# First the script attempts to find the tags database. You may specify one on
# the command line (eg: "nanoctags.sh <sometag> <dbfile>"), in the environment
# variable $TAGFILE, or let the script locate it for you. It searches the
# current directory and the parent directories until it finds one. Next it
# locates the relevant entry in the database. If you are not in the root of your
# source directory then it will search first for entries within your current
# directory, and then each of its parent directories until it reaches the folder
# containing the tags file. This means that if there are multiple definitions of
# the same name then it will try to find the one closest to where you are (and
# therefore hopefully the one you are looking for). Once the most appropriate
# entry is found, it is parsed and used to determine the correct filename and
# line number. Finally, Nano is opened at the correct location.
#
################################################################################


#save PWD
olddir="$PWD"
#first see if tag file specified on command line
tags="$2"
#if not then try environment
[ -e "$tags" ] || tags="$TAGFILE"
#if not then look for it in this directory and its parents
[ -e "$tags" ] || {
	last=""
	while true; do
		[ -e "tags" ] && { tags="${PWD}/tags"; break; }
		#if we're the same place we were before we tried to move up a directory then we've hit the root, or an error
		[ "$PWD" == "$last" ] && { echo "can't find tags file"; exit; }
		last="$PWD"
		cd .. || { echo "error finding tags file"; exit; }
	done

}

#find root of the directory structure ctags covers
root="$(dirname "$tags")"

#find the directory we started in, relative to the one containing ctags
rdir="$(echo "$olddir"|sed "s#${root}/##")"

#locate a line for this tag, first looking for matches within the current directory, then parents, then globally
while true; do
	string="$(grep -m 1 "^$1	$rdir" "$tags")"
	[ -n "$string" ] && break;
	last="$rdir"
	rdir="$(dirname "$rdir")"
	[ "$rdir" == "$last" ] && break
done
[ -n "$string" ] || { string="$(grep -m 1 "^$1	" "$tags")"; }
[ -n "$string" ] || { echo "tag $1 not found"; exit; }

#get the filename part
file="$(echo "$string"|cut -f 2)"

#get the location part
location="$(echo "$string"|cut -f 3-|sed "s/;.[^;]*$//"|sed "s,^[/?].,,"|sed 's,.[/?]$,,')"

#first see if it's a number
line="$(echo "$location"|grep -o "^[0-9]*")"

#if not then it's a pattern (match it as a non-regex pattern)
[ -n "$line" ] || line="$(grep -m 1 -nF "$location" "$file"|cut -d ":" -f 1)"

#if all else fails then just go to the top of the file
[ -n "$line" ] || line=1

#finally run nano
nano "+$line" "$root/$file"

