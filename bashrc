# .bashrc

if [ -f $HOME/.shellrc ]; then
    . $HOME/.shellrc
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [ -f "$(which powerline-daemon 2 &>1)" ]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    . /usr/share/powerline/bash/powerline.sh
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [ -f $HOME/.scalerc ]; then
    . $HOME/.scalerc
fi
