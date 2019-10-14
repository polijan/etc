#!/bin/bash
#^--- not to be executed directly, this is just for editors' syntax hilighting

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# or  /usr/share/doc/bash-doc/examples in the bash-doc package
# for examples


################################################################################
# IF NOT RUNNING INTERACTIVELY, DO NOT DO ANYTHING                             #
################################################################################
#                                                                              #
# I understood that a .bashrc is only sourced for interactive Bash shells so   #
# there should be no need for .bashrc to check if it is running in an          #
# interactive shell. Confusingly, all the distributions I use (Ubuntu, RHEL    #
# and Cygwin) had some type of check (testing $- or $PS1) to ensure the        #
# current shell is interactive. I don’t like cargo cult programming so I set   #
# about understanding the purpose of this code in my .bashrc.                  #
#                                                                              #
# Reason why it's needed is that: BASH HAS A SPECIAL CASE FOR REMOTE SHELLS !  #
#                                 =========================================    #
#                                                                              #
# Remote shells are treated differently. While non-interactive Bash shells     #
# don’t normally run ~/.bashrc commands at start-up, a special case is made    #
# when the shell is Invoked by remote shell daemon.   From Bash's man page:    #
#                                                                              #
# > Bash  attempts  to  determine when it is being run with its standard input #
# > connected to a network connection, as when executed by  the  remote  shell #
# > daemon, usually rshd, or the secure shell daemon sshd.  If bash determines #
# > it is being run in this fashion,  it  reads  and  executes  commands  from #
# > ~/.bashrc  and  ~/.bashrc, if these files exist and are readable.  It will #
# > not do this if invoked as sh.  The --norc option may be  used  to  inhibit #
# > this  behavior,  and the --rcfile option may be used to force another file #
# > to be read, but neither rshd nor sshd  generally  invoke  the  shell  with #
# > those options or allow them to be specified.                               #
#                                                                              #
################################################################################
# SEE MORE AT: https://unix.stackexchange.com/questions/257571/why-does-bashrc-check-whether-the-current-shell-is-interactive

# An  interactive shell is one started without non-option argu‐
# ments and without the -c  option  whose  standard  input  and
# error  are  both  connected  to  terminals  (as determined by
# isatty(3)), or one started with the -i option.   PS1  is  set
# and  $-  includes  i if bash is interactive, allowing a shell
# script or a startup file to test this state.
[[ $- != *i* ]] && return
##case $- in
##    *i*) ;;
##      *) return;;
##esac

################################################################################



#########################################################
# And now, we just gonna include ~/.shrc                #
# (to understand why by read my comments in ~/.profile) #
#########################################################

[ -n "$DEBUG_SH" ] && printf 'DEBUG (~/.bashrc): this is ~/.bashrc\n' >&2
. "$HOME/.shrc"
