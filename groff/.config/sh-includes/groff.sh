#!/bin/sh

# Colors in Man on modern GNU systems.
# see: https://unix.stackexchange.com/questions/108699/documentation-on-less-termcap-variables
#
# Step 1. Set up the LESS_TERMCAP_* variables (see my less config)
#
# Step 2. Groff
#   Groff is the part of Man that formats a man page for display on a terminal
#   or in print.  As of Groff 1.23, configuring less(1) has no effect on man
#   pages, because groff(1) directly emits terminal escape sequences instead of
#   letting less(1) do the translation. But you can use the classic less-based
#   rendering by setting the environment variable GROFF_NO_SGR to a non-empty
#   value.

GROFF_NO_SGR=use_less
export GROFF_NO_SGR
