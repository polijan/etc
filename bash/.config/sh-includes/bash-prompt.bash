#!/bin/bash
#^--- not to be executed directly, this is just for editors' syntax hilighting


################################################################################
# MY "POWER" PROMPT DEFINITION
################################################################################

# SHORTENING PATH IN BASH PROMPT: if PROMPT_DIRTRIM variable is set to a number
# greater than zero, the value is used as the number of trailing directory
# components to retain when expanding the \w and \W prompt string escapes.
# Characters removed are replaced with an ellipsis.
PROMPT_DIRTRIM=3

# PROMPT_COMMAND is executed prior to issuing primary prompt
PROMPT_COMMAND='__ps1_create'

__ps1_segment() {
   # creates small separation between colored block in PS1
   #
   # usage: __ps1_segment FG BG
   # => adds a right half block colored with BG, then sets up FG & BG colors
   #
   # usage: __ps1_segment FG
   # => adds a left half block colored with FG, reset attributes to default

   local SEP=$'\U2590' # RIGHT HALF BLOCK
   local FIN=$'\U258C' # LEFT HALF BLOCK
   PS1+='\[\e['

   if [ -n "$2" ]; then
      # put foreground color as the given bg
      # prints the separator
      if   [ "$2" -le 7  ]; then PS1+="3$2"
#      elif [ "$2" -le 15 ]; then PS1+="9$(($2-8))"
                            else PS1+="38;5;$2"
      fi
      PS1+="m\]$SEP\[\e["
   else
      # reset attributes
      PS1+='0;'
   fi

   # sets foreground
   if   [ "$1" -le 7  ]; then PS1+="3$1"
#   elif [ "$1" -le 15 ]; then PS1+="9$(($1-8))"
                         else PS1+="38;5;$1"
   fi

   if [ -n "$2" ]; then
      PS1+=';'
      # sets background
      if   [ "$2" -le 7  ]; then PS1+="4$2"
#      elif [ "$2" -le 15 ]; then PS1+="10$(($2-8))"
                          else PS1+="48;5;$2"
      fi
   else
      # reset background, prints final separator, reset
      PS1+="m\]$FIN\[\e[0"
   fi
   PS1+='m\]'
}

if ! exists git; then
__ps1_git() { :; } # if we don't have git(1), do nothing!
else
__ps1_git() {
   # usage: set up a segment with git info

   # get current branch name or short SHA1 hash for detached head
   local branch
   branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null ||
             git describe --tags --always 2>/dev/null)"
   [ -n "$branch" ] || return  # git branch not found
   #__ps1_segment 15 8
   __ps1_segment 33 230
   PS1+="$branch"

   # branch is modified?
   [ -n "$(git status --porcelain)" ] && PS1+='*'

   # how many commits local branch is ahead/behind of remote?

   local ahead=$'\U2191'  # UPWARDS ARROW
   local behind=$'\U2193' # DOWNWARDS ARROW
   local stat aheadN behindN
   stat="$(git rev-list --left-right --boundary @{u}... 2>/dev/null)"
   aheadN="$( grep -o '>' -c <<< "$stat")"
   behindN="$(grep -o '<' -c <<< "$stat")"
   [ "$aheadN" -gt 0 ]  && PS1+=" $ahead$aheadN"
   [ "$behindN" -gt 0 ] && PS1+=" $behind$behindN"
}
fi

__ps1_create() {
  local ret=$?
  #         ^--- must be first line, capture the exit status of the
  #              previous shell command.

  # usage: __ps1_create
  # dynamically construct a nice PS1 prompt with colors, etc.
  # In bash, enable it like this: PROMPT_COMMAND='__ps1_create'


  # Since we use half block separator to separate segments, we can use
  # the small space between the beginning on line and the first segment
  # as a small color indicator... let's use it to to tell me if it is
  # late or not (I tend to forget time when working with the computer).
  PS1='\[\e[0;' # reset char attributes, then start another sequence
  local H; H=$(date +%H)
  case "$H" in
       22) PS1+='43' ;; # it starts to be late  => yellow
       23) PS1+='41' ;; # don't compute late    => red
   0[0-5]) PS1+='101';; # don't compute so late => bright red
        *) PS1+='48;5;235';; # ok               => lightblack
  esac
  PS1+='m\]'

  # for graphical terminals and tmux, set the title bar (to user@host:dir)
  case "$TERM" in xterm*|rxvt*|screen*)
     PS1+='\[\e]0;\u@\h:\w\a\]';;
  esac

  # add host in the prompt if we are SSH'ing
  [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]] && { __ps1_segment 4 7; PS1+='\h'; }

  # mj shell
  [[ -n "$MJ_SHELL" ]] && { __ps1_segment 7 166 ; PS1+='mj'; }

  # current directory
  __ps1_segment 250 241 # base2 on base00
  PS1+='\w'

  # git status ...
  __ps1_git

  # number of background jobs, if there are any
  [ "$(jobs | wc -l)" -ne 0 ] && { __ps1_segment 7 5; PS1+='\j'; }

  # GTD
  [ -n "$GTD_SHELL" ] && { __ps1_segment 0 1; PS1+='GTD'; }

  # shell symbol, with different bg color depending on the return code
  local bgc
  case $ret in
    0) bgc=2 ;; # $?=0 => green
    1) bgc=3 ;; # $?=1 => yellow
    *) bgc=1 ;; # else => red
  esac
  __ps1_segment 7 $bgc
  PS1+='\$'
  __ps1_segment $bgc # final call
}
