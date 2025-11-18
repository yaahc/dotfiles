# .bashrc
. /home/yaahc/.nix-profile/etc/profile.d/nix.sh

if [ -f "$HOME/.shellrc" ]; then
    . "$HOME/.shellrc"
fi

if [ -f "$HOME/.aliasrc" ]; then
    . "$HOME/.aliasrc"
fi


# Source global definitions
if [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
fi

# User specific aliases and functions
[ -f ~/.aliasrc ] && source ~/.aliasrc

# User specific aliases and functions
[ -f "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
# shellcheck source=/dev/null
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        source "$BASE16_SHELL/profile_helper.sh"
if [ -f base16_default-dark ]; then
    base16_default-dark
fi

if hash base16_default-dark 2>/dev/null; then
    base16_default-dark
fi

alias vim=nvim

[[ -f "$HOME/.bash-preexec.sh" ]] && source "$HOME/.bash-preexec.sh"
eval "$(starship init bash)"

export NVM_DIR="$HOME/.config/nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# shellcheck source=/dev/null
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"
export PATH="$PATH:/home/jlusby/.influxdb/"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

. "$HOME/.atuin/bin/env"

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"

source <(COMPLETE=bash jj)
