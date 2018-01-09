#xset +fp /usr/share/fonts/local
#xset fp rehash

# export BSPWM_SOCKET="/tmp/bspwm-socket"
# export PANEL_FIFO="/tmp/panel-fifo"
# export PANEL_HEIGHT=18
# export DEV_ILCU_ADDR=10.152.20.120

#dropboxd &
# Keep this at the bottom or killing it will prevent anything below it from being sourced
# eval $(keychain --eval --quiet id_rsa ~/.ssh/id_rsa)

. $HOME/.profile

if [ "$TERM" != "screen" ]; then
    tmux attach -t Dev
fi
