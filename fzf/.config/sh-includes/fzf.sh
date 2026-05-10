#!/bin/sh

# ███████╗███████╗███████╗
# ██╔════╝╚══███╔╝██╔════╝
# █████╗    ███╔╝ █████╗
# ██╔══╝   ███╔╝  ██╔══╝
# ██║     ███████╗██║
# ╚═╝     ╚══════╝╚═╝

#-------------------------------------------------------------------------------
# Color options for fzf
#-------------------------------------------------------------------------------

FZF_DEFAULT_OPTS='--color=base16,list-bg:0'
[ -z "$THEME_BASE02" ] || FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=bg+:#${THEME_BASE02}"

#-------------------------------------------------------------------------------
# Non-color default options for fzf
#-------------------------------------------------------------------------------

# * General     => ansi (required to pass colors to fzf) + layout=reverse
# * Options for each fzf sections:
#   - Input     => border + inline-right + the following key-bindings:
#                  - ctrl-k=kill-line <-- ctrl-j/k is up/down by default to give
#                                         a "vi"-vibe, but it's more important
#                                         for me to have input behave like
#                                         default "readline")
#                  - alt-j/k <-- remap to up/down as we change ctrl-k
#                  - more keys (alt-home/end <-- first/last, ...)
#   - Header    => note: --header-lines could have its own separate border
#   - List      => highlight-line (so much prettier) + ellipsis=…
#   - Preview   => * provide a default "adaptative" (right, but alternatively
#                    down) preview window.
#                  * bind some keys to control the preview window
#   - Footer    => put border, etc.
FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS                           \
   \
   --ansi                                                     \
   --layout=reverse                                           \
   \
   --highlight-line                                           \
   --ellipsis=…                                               \
   \
   --input-border                                             \
   --prompt '❯ '                                              \
   --info=inline-right                                        \
   --bind 'ctrl-k:kill-line'                                  \
   --bind 'alt-j:down'                                        \
   --bind 'alt-k:up'                                          \
   --bind 'alt-home:first'                                    \
   --bind 'alt-end:last'                                      \
   \
   --header-border=none                                       \
   \
   --preview-window 'right:66%,<62(bottom,66%)'               \
   --bind 'alt-z:toggle-preview'                              \
   --bind 'alt-x:change-preview-window(right:66%|bottom,66%)' \
   --bind 'alt-w:toggle-preview-wrap'                         \
   --bind 'shift-home:preview-top'                            \
   --bind 'shift-end:preview-bottom'                          \
   --bind 'shift-page-up:preview-page-up'                     \
   --bind 'shift-page-down:preview-page-down'                 \
   --bind 'shift-left:preview-half-page-up'                   \
   --bind 'shift-right:preview-half-page-down'                \
   \
   --footer-border                                            \
   --footer-label-pos=-3:Top                                  "

export FZF_DEFAULT_OPTS


#-------------------------------------------------------------------------------
# Integration of fzf with the shell
#-------------------------------------------------------------------------------
# The integrations provided by the fzf project are:
# * Ctrl-r: Access command history and paste them into the command line
# * Ctrl-t: Choose file paths and paste them into the command line
# * Alt-c : Choose a directory with fzf and cd into it
#-------------------------------------------------------------------------------

if   [ -d "$HOME/.local/src/fzf/.git" ]; then
     FZF_SHELL="$HOME/.local/src/fzf/shell"
     fzf_upgrade() { # function to upgrade the fzf binary with git
        ( cd "$HOME/.local/src/fzf" && git pull && ./install --bin )
     }
     alias upgrade-fzf=fzf_upgrade
elif [ -d "/usr/share/fzf/shell" ]      ; then FZF_SHELL="/usr/share/fzf/shell"
elif [ -d "/usr/share/fzf" ]            ; then FZF_SHELL="/usr/share/fzf"
elif [ -d "/usr/local/share/fzf/shell" ]; then FZF_SHELL="/usr/local/share/fzf/shell"
elif [ -d "/usr/local/share/fzf" ]      ; then FZF_SHELL="/usr/local/share/fzf"
elif is-termux                          ; then FZF_SHELL="$PREFIX/share/fzf"
fi

#shellcheck source=/dev/null
if [ -n "$FZF_SHELL" ]; then
   # shell completion
   [ -n "$BASH_VERSION" ] && . "$FZF_SHELL/completion.bash"
   [ -n "$ZSH_VERSION" ]  && . "$FZF_SHELL/completion.zsh"
   # shell key bindings
   [ -n "$BASH_VERSION" ] && . "$FZF_SHELL/key-bindings.bash"
   [ -n "$ZSH_VERSION" ]  && . "$FZF_SHELL/key-bindings.zsh"
   unset FZF_SHELL
fi


#-------------------------------------------------------------------------------
# Functions for tui wrappers
#-------------------------------------------------------------------------------

if exists man; then
man() {
   if [ $# -eq 0 ] && [ -t 0 ] && [ -t 1 ]
      then tui-man
      else command man "$@"
   fi
}
fi

tldr() {
   if [ $# -eq 0 ] && [ -t 0 ] && [ -t 1 ]
      then tui-tldr
      else command tldr "$@"
   fi
}
