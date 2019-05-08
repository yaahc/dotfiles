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

[ -f ~/.scbuild.bash ] && source ~/.scbuild.bash
