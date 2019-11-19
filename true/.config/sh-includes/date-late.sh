#!/bin/sh

# Usage: $0
# display the date and message if it's "late"

date
case $(date +%H) in
   0[0-4]) printf "\033[1;37;41mIT'S VERY LATE! GO TO SLEEP!!!\033[0m\n"          ;;
    22|23) printf "\033[30;43mIT'S LATE! TIME TO TURN OFF THE COMPUTER!\033[0m\n" ;;
esac
