if hash "xset" 2> /dev/null; then
    xset +fp /usr/share/fonts/local
    xset fp rehash
fi

if hash zsh 2> /dev/null; then
    export SHELL="/usr/bin/zsh"
    exec $SHELL
else
    source ~/.bashrc
fi
export PATH='/bin:/sbin':"$PATH"
