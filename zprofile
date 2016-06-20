#xset +fp /usr/share/fonts/local
#xset fp rehash

export XDG_CONFIG_HOME="$HOME/.config"
# export BSPWM_SOCKET="/tmp/bspwm-socket"
# export PANEL_FIFO="/tmp/panel-fifo"
# export PANEL_HEIGHT=18
export PATH=$HOME/Scripts:$PATH:/opt/java/bin
export SHCC=$HOME/sdks/ti-processor-sdk-linux-am57xx-evm-02.00.01.07/linux-devkit/sysroots/x86_64-arago-linux/usr/bin/arm-linux-gnueabihf-
export DEV_ILCU_ADDR="10.152.20.134 10.152.20.136"
# export DEV_ILCU_ADDR=10.152.20.120
export MAKEFLAGS=-j7

#eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
#export GNOME_KEYRING_CONTROL 
#export GNOME_KEYRING_PID 
#export GPG_AGENT_INFO 
#export SSH_AUTH_SOCK

#dropboxd &
# Keep this at the bottom or killing it will prevent anything below it from being sourced
# eval $(keychain --eval --quiet id_rsa ~/.ssh/id_rsa)
