#!/usr/bin/env bash

# Usage: $0
# A Forth interpreter written in Bash
#
#
# from: https://github.com/izabera/forth
# retrieved on 2023-09-24
#
#
# \ This is a comment
# ( This is also a comment but it's only used when defining words )
#
# \ --------------------------------- Precursor ----------------------------------
#
# \ All programming in Forth is done by manipulating the parameter stack (more
# \ commonly just referred to as "the stack").
# 5 2 3 56 76 23 65    \ ok
#
# \ Those numbers get added to the stack, from left to right.
# .s    \ <7> 5 2 3 56 76 23 65 ok
#
# \ In Forth, everything is either a word or a number.
#
# \ ------------------------------ Basic Arithmetic ------------------------------
#
# \ Arithmetic (in fact most words requiring data) works by manipulating data on
# \ the stack.
# 5 4 +    \ ok
#
# \ `.` pops the top result from the stack:
# .    \ 9 ok
#
# \ More examples of arithmetic:
# 6 7 * .        \ 42 ok
# 1360 23 - .    \ 1337 ok
# 12 12 / .      \ 1 ok
# 13 2 mod .     \ 1 ok
#
# 99 negate .    \ -99 ok
# -99 abs .      \ 99 ok
# 52 23 max .    \ 52 ok
# 52 23 min .    \ 23 ok
#
# \ ----------------------------- Stack Manipulation -----------------------------
#
# \ Naturally, as we work with the stack, we'll want some useful methods:
#
# 3 dup -          \ duplicate the top item (1st now equals 2nd): 3 - 3
# 2 5 swap /       \ swap the top with the second element:        5 / 2
# 6 4 5 rot .s     \ rotate the top 3 elements:                   4 5 6
# 4 0 drop 2 /     \ remove the top item (don't print to screen):  4 / 2
# 1 2 3 nip .s     \ remove the second item (similar to drop):    1 3
#
# \ ---------------------- More Advanced Stack Manipulation ----------------------
#
# 1 2 3 4 tuck   \ duplicate the top item below the second slot:      1 2 4 3 4 ok
# 1 2 3 4 over   \ duplicate the second item to the top:             1 2 3 4 3 ok
# 1 2 3 4 2 roll \ *move* the item at that position to the top:      1 3 4 2 ok
# 1 2 3 4 2 pick \ *duplicate* the item at that position to the top: 1 2 3 4 2 ok
#
# \ When referring to stack indexes, they are zero-based.
#
# \ ------------------------------ Creating Words --------------------------------
#
# \ The `:` word sets Forth into compile mode until it sees the `;` word.
# : square ( n -- n ) dup * ;    \ ok
# 5 square .                     \ 25 ok
#
# \ We can view what a word does too:
# see square     \ : square dup * ; ok
#
# \ -------------------------------- Conditionals --------------------------------
#
# \ 1 == true, 0 == false. However, any non-zero value is usually treated as
# \ being true:
# 42 42 =    \ -1 ok
# 12 53 =    \ 0 ok
#
# \ `if` <stuff to do> `then` <rest of program>.
# : ?>64 ( n -- n ) dup 64 > if ." Greater than 64! " then ; \ ok
# 100 ?>64                                                  \ Greater than 64! ok
#
# \ Else:
# : ?>64 ( n -- n ) dup 64 > if ." Greater than 64! " else ." Less than 64! " then ;
# 100 ?>64    \ Greater than 64! ok
# 20 ?>64     \ Less than 64! ok
#
# \ ------------------------------------ Loops -----------------------------------
#
# : myloop ( -- ) 5 0 do cr ." Hello! " loop ; \ ok
# myloop
# \ Hello!
# \ Hello!
# \ Hello!
# \ Hello!
# \ Hello! ok
#
# \ `do` expects two numbers on the stack: the end number and the start number.
#
# \ We can get the value of the index as we loop with `i`:
# : one-to-12 ( -- ) 12 0 do i . loop ;     \ ok
# one-to-12                                 \ 0 1 2 3 4 5 6 7 8 9 10 11 12 ok
#
# \ ---------------------------- Variables and Memory ----------------------------
#
# \ Use `variable` to declare `age` to be a variable.
# variable age    \ ok
#
# \ Then we write 21 to age with the word `!`.
# 21 age !    \ ok
#
# \ Finally we can print our variable using the "read" word `@`, which adds the
# \ value to the stack, or use `?` that reads and prints it in one go.
# age @ .    \ 21 ok
# age ?      \ 21 ok
#
# \ Constants are quite similar, except we don't bother with memory addresses:
# 100 constant WATER-BOILING-POINT    \ ok
# WATER-BOILING-POINT .               \ 100 ok




#!/bin/bash

pop () {
  while (( $# )); do
    eval "$1=\${stack[-1]}"
    unset "stack[-1]"
    shift
  done
}

push () { stack+=("$@"); }

output () { echo -n "$* "; }

declare -A funcs variables constants

evaluate () {
  local a b c
  while (( $# )); do
    if [[ -v "funcs[${1@Q}]" ]]; then
      eval evaluate "${funcs[$1]}"
    elif [[ -v "constants[${1@Q}]" ]]; then
      push "${constants[$1]:-0}"
    else
      case ${1,,} in
        '\') break;;
        [-+*/%]) pop a b; push "$((a $1 b))";;
        .) pop a; output "$a";;
        dup) pop a; push "$a" "$a";;
        .s) output "${stack[*]}";;
        swap) pop a b; push "$a" "$b";;
        abs) pop a; push "${a#-}";;
        negate) pop a; push "$((-a))";;
        drop) pop a;;
        max) pop a b; push "$((a > b ? a : b))";;
        min) pop a b; push "$((a < b ? a : b))";;
        bye) exit ;;
        nip) pop a b; push "$a";;
        tuck) pop a b; push "$a" "$b" "$a";;
        rot) pop a b c; push "$b" "$a" "$c";;
        over) pop a b; push "$b" "$a" "$b";;
        pick) pop a; push "${stack[-a-1]}";;
        roll) pop a
              stack=(
                     "${stack[@]::${#stack[@]}-1-a}"
                     "${stack[@]: -a}"
                     "${stack[-a-1]}"
                     )
                     ;;
        =) pop a b; push "$((a == b))";;
        ['><'])  pop a b; push "$((b $1 a))";;
        '(') while [[ $1 != ')' ]]; do shift; done ;;
        cr) output $'\n';;
        .\") string=
             shift
             while [[ $1 != '"' ]]; do string+="$1 "; shift; done
             output "$string"
             ;;
        :) name="$2" code=
           shift 2
           while [[ $1 != ';' ]]; do
             code+="${1@Q} "
             shift
           done
           funcs[$name]=$code
           ;;
        see) shift; output "${funcs[$1]}";;
        do) local i=0 code=
            shift
            while [[ ${1,,} != loop ]]; do
              code+="${1@Q} "
              shift
            done
            pop a b
            while (( a+i != b )); do
              eval evaluate "$code"
              (( i += a < b ? 1 : -1 ))
            done
            ;;
        \?do) local i=0 code=
            shift
            while [[ ${1,,} != loop ]]; do
              code+="${1@Q} "
              shift
            done
            pop a b
            while (( a+i != b )); do
              eval evaluate "$code"
              (( i += a < b ? 1 : -1 ))
            done
            ;;
        i) push "$i" ;;
        begin) code=
               shift
               while [[ ${1,,} != until ]]; do
                 code+="${1@Q} "
                 shift
               done
               while :; do
                 eval evaluate "$code"
                 pop a; (( a )) && break
               done ;;
        if) local code=() q=0
            shift
            while [[ ${1,,} != then ]]; do
              [[ ${1,,} = else ]] && ((++q)) || code[q]+="${1@Q} "
              shift
            done
            pop a
            eval evaluate "${code[!a]}"
            ;;
        constant) shift; pop "constants[$1]";;
        variable) shift; variables[$1]=0;;
        !) pop name val; variables[$name]=$val;;
        @) pop name; push "${variables[$name]}";;
        \?) pop name; output "${variables[$name]}";;
        clearstack) stack=() ;;
        *) push "$1";;
      esac
    fi
    shift
  done
}

while read -re; do
  history -s -- "$REPLY"
  read -ra input <<< "$REPLY"
  echo -n $'\e[32m>\e[m '
  evaluate "${input[@]}"
  echo $'\e[32mok\e[m'
done
