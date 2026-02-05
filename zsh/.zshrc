################################################################################
# Theme: Powerlevel-10k "theme" (requires proper font also)
# see: https://github.com/romkatv/powerlevel10k
################################################################################

#When using Powerlevel10k with instant prompt, console output during zsh
#initialization may indicate issues.
# For details, see: https://github.com/romkatv/powerlevel10k#instant-prompt
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# # Initialization code that may require console input (password prompts, [y/n]
# # confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Include powerlevel10k
if [ -f   "$HOME"/.local/share/zsh/powerlevel10k/powerlevel10k.zsh-theme ]; then
   source "$HOME"/.local/share/zsh/powerlevel10k/powerlevel10k.zsh-theme
elif               [ -f /usr/share/powerlevel10k/powerlevel10k.zsh-theme ]; then
   source               /usr/share/powerlevel10k/powerlevel10k.zsh-theme
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



################################################################################
# Include ~/.shrc
# (to understand why by read my comments in ~/.profile)
################################################################################

[ -n "$DEBUG_SH" ] && printf 'DEBUG (~/.bashrc): this is ~/.bashrc\n' >&2
. "$HOME/.shrc"


################################################################################
# Include Popular "Plugins" for zsh
# Assume local install in ~/.local/share/zsh/*/
# or system-wide install in /usr/share/
################################################################################

# zsh-syntax-highlighting
# see: https://github.com/zsh-users/zsh-syntax-highlighting/
if [ -f   "$HOME"/.local/share/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
   source "$HOME"/.local/share/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f               /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
   source               /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# zsh-autosuggestions.zsh
# especially for config, see: https://github.com/zsh-users/zsh-autosuggestions/
if [ -f   "$HOME"/.local/share/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
   source "$HOME"/.local/share/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
elif               [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
   source               /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

################################################################################
# Zsh config
################################################################################

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/polijan/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
