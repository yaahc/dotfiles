#! /bin/bash

install_apt ()
{
    # - $1 is package name and required TODO assert that its set
    # - $2 is bin name (if your package adds multiple bins just pick one) and is
    #   optional, if not set it assumes bin name matches package name
    if [ "x$2" = "x" ]; then
        bin_name="$1"
    else
        bin_name="$2"
    fi

    if ! hash "$bin_name"; then
        sudo apt-get -y install "$1"
        echo
        return $?
    else
        echo "$bin_name is already installed"
    fi

    echo
    return 0
}

install_pip ()
{
    # - $1 is package name and required TODO assert that its set
    # - $2 is bin name (if your package adds multiple bins just pick one) and is
    #   optional, if not set it assumes bin name matches package name
    if [ "x$2" = "x" ]; then
        bin_name="$1"
    else
        bin_name="$2"
    fi

    if ! hash "$bin_name"; then
        sudo pip install "$1"
        echo
        return $?
    else
        echo "$bin_name is already installed"
    fi

    echo
    return 0
}

switch_shell ()
{
    OLD_SHELL="$(getent passwd "$LOGNAME" | cut -d: -f7)"
    NEW_SHELL="$(type -p "$1")"
    if [ "$OLD_SHELL" != "$NEW_SHELL" ]; then
        chsh --shell "$NEW_SHELL"
    fi
}

install_apt zsh
switch_shell zsh

install_apt keychain
install_apt vim
# install_apt rustc
# install_apt cargo

# fzf
# ripgrep (hard because not in apt) (jk do it with cargo)

# compile ycm
# cd dotfiles/vim/bundle/vim-youcompleteme
# ./install --clang-completer
#     - look into installing bear to get completion on gcc projects
#     - Probably give up on clang completion, I dont think it worked on my
#       datalogic projects, but tags completion does!

# install_apt cmake # redundant?
install_apt cmake3 cmake
install_apt build-essential
install_apt python-dev python
install_apt python3-dev python3
install_apt python-numpy # I don't know how to check if numpy is installed
install_apt golang-go
install_apt python-pip pip

# static analysis checkers
install_apt cppcheck
install_pip prospector
install_pip bashate
install_apt devscripts checkbashisms # checkbashisms
# you have to enable trusty-backports on ubuntu 14.04 inorder to get this download to work
install_apt shellcheck
