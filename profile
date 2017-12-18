if hash "xset" 2> /dev/null; then
    xset +fp /usr/share/fonts/local
    xset fp rehash
fi

if hash "/usr/bin/zsh"; then
    export SHELL="/usr/bin/zsh"
    exec $SHELL
fi
export PATH='/bin:/sbin':"$PATH"
