#!/bin/bash
DESCRIPTION='Colorfully blocky thingy'
# This is free and unencumbered software released into the public domain.
# 
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
# 
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
# 
# For more information, please refer to <http://unlicense.org/>

VERSION=0.1.0

# blocky factor
b=50

# render intervals
t=0
T=0

# minimum dividable width and height
MIN_W=4
MIN_H=2

# keep running interval
k=0

# no color characters
C=

# maximum value of $RANDOM + 1
M=32768


fill()
{
  # (X1, Y1) is top-left ; (X2, Y2) is bottom-right
  local X1=$1 Y1=$2 W=$3 H=$4
  local X2=$((X1 + W - 1)) Y2=$((Y1 + H - 1))

  # generate one line of the filled area
  local c line
  printf -v line '%*s' $W
  if [[ $C ]]; then
    c=${C:RANDOM * ${#C}/ M:1}
    line="${line// /$c}"
  else
    c=$((RANDOM * 6 / M + 1))
    line="\e[1;4${c}m$line\e[0m"
  fi

  local y
  for ((y=Y1; y<=Y2; y++)); do
    echo -ne "\e[${y};${X1}H"
    echo -ne "$line"
    [[ $T != 0 ]] && sleep $T
  done
  [[ $t != 0 ]] && sleep $t
}


divide()
{
  local W=$3 H=$4
  # change to escape, for bigger blocks
  ((10000 * W * H / (SW * SW) < RANDOM * b / M)) && return

  # (X1, Y1) is top-left ; (X2, Y2) is bottom-right
  local X1=$1 Y1=$2
  local X2=$((X1 + W - 1)) Y2=$((Y1 + H - 1))

  # check dividable
  local CAN_DIV_W=$((W >= MIN_2W))
  local CAN_DIV_H=$((H >= MIN_2H))

  # decide to divide Width or Height
  if ((CAN_DIV_W + CAN_DIV_H == 2)); then
    ((RANDOM % 2)) && CAN_DIV_W=0
  elif ((CAN_DIV_W + CAN_DIV_H == 0)); then
    return
  fi

  if ((CAN_DIV_W)); then
    local lw=$((RANDOM * (W - MIN_2W) / M + MIN_W + 1))
    fill $X1 $Y1 $lw $H
    divide $X1 $Y1 $lw $H

    local rx=$((X1 + lw))
    local rw=$((W - lw))
    divide $rx $Y1 $rw $H
  else
    local uh=$((RANDOM * (H - MIN_2H) / M + MIN_H + 1))
    fill $X1 $Y1 $W $uh
    divide $X1 $Y1 $W $uh

    local by=$((Y1 + uh))
    local bh=$((H - uh))
    divide $X1 $by $W $bh
  fi
}


parse()
{
  local arg

  while getopts b:W:H:t:T:k:C:hv arg; do
    [[ $arg == '?' ]] && exit 1
    case $arg in
      b)
        ((b = OPTARG >= 0 ? OPTARG : b))
        ;;
      W)
        ((MIN_W = OPTARG >= 2 ? OPTARG : MIN_W))
        ;;
      H)
        ((MIN_H = OPTARG >= 2 ? OPTARG : MIN_H))
        ;;
      t)
        t="$OPTARG"
        ;;
      T)
        T="$OPTARG"
        ;;
      k)
        k="$OPTARG"
        ;;
      C)
        C="$OPTARG"
        ;;
      h)
        echo "Usage: $(basename $0) [OPTIONS]
$DESCRIPTION

Options:

  -b # >= 0       blocky factor [$b]
  -W # >= 2       minimum width [$MIN_W]
  -H # >= 2       minimum height [$MIN_H]
  -t # >= 0       block render interval [$t]
  -T # >= 0       block line render interval [$T]
  -k # >= 0       keep running interval [$k]
  -C X            no color characters [unset]
  -h              this help message
  -v              print version number

Keys:

  [Q] / [Escape]  quit
  anything else   new blocky
"
        exit 0
        ;;
      v)
        echo "$(basename -- "$0") $VERSION"
        exit 0
    esac
  done
}


resize()
{
  SW=$(tput cols)
  SH=$(tput lines)
}


cleanup()
{
  # empty standard input
  read -t 0.001 && cat </dev/stdin>/dev/null

  # terminal has no smcup and rmcup capabilities
  ((FORCE_RESET)) && reset && exit 0

  tput rmcup
  tput cnorm
  stty echo
  [[ $C ]] || echo -ne '\e[0m'
  exit 0
}


main()
{
  parse "$@"

  trap resize SIGWINCH
  trap cleanup EXIT HUP INT TERM

  # disable echoing on standard input and hide the cursor
  stty -echo
  tput smcup || FORCE_RESET=1
  tput civis
  tput clear

  resize
  MIN_2W=$((2 * MIN_W))
  MIN_2H=$((2 * MIN_H))
  [[ $k != 0 ]] && k="-t $k" || k=
  while :; do
    fill 1 1 $SW $SH
    divide 1 1 $SW $SH

    read $k -n 1
    [[ $REPLY == [qQ$'\x1b'] ]] && break
  done
}


main "$@"
