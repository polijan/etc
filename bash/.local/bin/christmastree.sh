#!/bin/bash
# usage: christmastree.sh      - prints a christmas tree
# usage: christmastree.sh loop - animate the christmas tree

################################################################################
YELLOW='\033[1;33m'; GREEN='\033[0;32m'; ORANGE='\033[0;33m'
BLUE='\033[0;34m'  ; WHITE='\033[1;37m'; RED='\033[0;31m'
RESET='\033[0m'

STAR='*'
C_STAR=$YELLOW

TREE=('8' '0' 'o' '@' \
    '*' '~' '-' '+' '^' '.' ',' '_' '=' '{' '}' ']' '[' ';' ':' '#' '$' '&' '!')
LIGHTS=("$YELLOW" "$BLUE" "$WHITE" "$RED")
C_TREE=$GREEN

TRUNK='#'
C_TRUNK=$ORANGE
################################################################################

xmastree() {
   local NLIGHTS=${#LIGHTS[@]}
   local NTREE=${#TREE[@]}

   local i j rand elem
   local W=$(( $(tput cols) / 2 ))
   local H=$(( $(tput lines) * 9 / 10 ))
   [ $H -gt $W ] && H=$W

   # buffers
   local star= tree=$C_TREE trunk=$C_TRUNK
   local str= spaces=
   for ((i=0; i<W; i++)); do
       spaces="$spaces "
   done

   # star
   star="${spaces:0:$((W-1))}$C_STAR$STAR\n"

   # tree
   for ((i=2; i<H; i++)); do
      for ((j=2; j < 2*i; j++)); do
          rand=$(( RANDOM % NTREE ))
          elem=${TREE[$rand]}
          if [ $rand -le $NLIGHTS ]
             then str="$str${LIGHTS[ $((RANDOM % NLIGHTS)) ]}$elem$C_TREE"
             else str="$str$elem"
          fi
      done
      tree="$tree${spaces:0:$((W-i))}$str\n"
      str=''
   done

   # trunk
   spaces="${spaces:0:$((W-H/4))}"
   for ((i=0; i < H/2; i++)); do
       str="$str$TRUNK"
   done
   for ((i=0; i < H/10; i++)); do
       trunk="$trunk$spaces$str\n"
   done

   printf %b "$star$tree$trunk$RESET"
}


[ "$1" = "loop" ] && exec watch --color -n .1 "$0"
xmastree "$@"
