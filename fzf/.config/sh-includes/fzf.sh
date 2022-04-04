#!/bin/sh

# default appearance and behaviour for fzf
export FZF_DEFAULT_OPTS='--ansi --reverse --inline-info --pointer=► --marker=» --ellipsis=… --color=dark,bg+:4,fg+:3'
#export FZF_DEFAULT_OPTS='--color=info:4,bg+:4,header:2 --ansi --reverse --inline-info'
# export FZF_DEFAULT_OPTS='--color=16,info:4,bg+:4,header:2 --ansi --reverse --inline-info'


# sort of solarized dark...
# --color=fg+:234,bg+:241,hl:136,hl+:166,border:235,prompt:33,pointer:61,marker:160,spinner:37,header:64

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
   [ -n "$ZH_VERSION" ]   && . "$FZF_SHELL/key-bindings.bash"
   unset FZF_SHELL
fi
