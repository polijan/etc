#!/bin/sh

alias g=grep-insI
alias gr=grep-rinsI

# "ripgrep" (command: rg) - https://github.com/BurntSushi/ripgrep
# is an alternative to grep which may or may not be installed.
exists rg || alias rg=grep-rinsI
