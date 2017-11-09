echo "Remember not to be lazy this time, put the password you use to encrypt the key into your password manager"

edkey="$HOME/.ssh/id_ed25519"
rsakey="$HOME/.ssh/id_rsa"

if [ ! -e $edkey ]; then
    ssh-keygen -t ed25519 -a 100 -f $edkey
fi

if [ ! -e $rsakey ]; then
    ssh-keygen -t rsa -b 4096 -o -a 100 -f $rsakey
fi

