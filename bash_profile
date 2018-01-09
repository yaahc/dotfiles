# echo "Sourcing .bash_profile"

# . "$HOME/.profile"

if [ -n "$BASH_VERSION" ] && [ -f $HOME/.bashrc ];then
    source $HOME/.bashrc
fi

# echo "Attaching screen"
# screen -dRR
