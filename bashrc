# .bashrc

if [ -f $HOME/.shellrc ]; then
    . $HOME/.shellrc
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        source "$BASE16_SHELL/profile_helper.sh"

alias vim=nvim
base16_default-dark
