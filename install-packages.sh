#! /bin/bash

set -e

lowercase(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

OS=`lowercase \`uname\``
KERNEL=`uname -r`
MACH=`uname -m`

if [ "{$OS}" == "windowsnt" ]; then
    OS=windows
elif [ "{$OS}" == "darwin" ]; then
    OS=mac
else
    OS=`uname`
    if [ "${OS}" = "SunOS" ] ; then
        OS=Solaris
        ARCH=`uname -p`
        OSSTR="${OS} ${REV}(${ARCH} `uname -v`)"
    elif [ "${OS}" = "AIX" ] ; then
        OSSTR="${OS} `oslevel` (`oslevel -r`)"
    elif [ "${OS}" = "Linux" ] ; then
        if [ -f /etc/redhat-release ] ; then
            DistroBasedOn='RedHat'
            DIST=`cat /etc/redhat-release |sed s/\ release.*//`
            PSUEDONAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
            REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
        elif [ -f /etc/SuSE-release ] ; then
            DistroBasedOn='SuSe'
            PSUEDONAME=`cat /etc/SuSE-release | tr "\n" ' '| sed s/VERSION.*//`
            REV=`cat /etc/SuSE-release | tr "\n" ' ' | sed s/.*=\ //`
        elif [ -f /etc/mandrake-release ] ; then
            DistroBasedOn='Mandrake'
            PSUEDONAME=`cat /etc/mandrake-release | sed s/.*\(// | sed s/\)//`
            REV=`cat /etc/mandrake-release | sed s/.*release\ // | sed s/\ .*//`
        elif [ -f /etc/debian_version ] ; then
            DistroBasedOn='Debian'
            DIST=`cat /etc/lsb-release | grep '^DISTRIB_ID' | awk -F=  '{ print $2 }'`
            PSUEDONAME=`cat /etc/lsb-release | grep '^DISTRIB_CODENAME' | awk -F=  '{ print $2 }'`
            REV=`cat /etc/lsb-release | grep '^DISTRIB_RELEASE' | awk -F=  '{ print $2 }'`
        fi
        if [ -f /etc/UnitedLinux-release ] ; then
            DIST="${DIST}[`cat /etc/UnitedLinux-release | tr "\n" ' ' | sed s/VERSION.*//`]"
        fi
        OS=`lowercase $OS`
        DistroBasedOn=`lowercase $DistroBasedOn`
        readonly OS
        readonly DIST
        readonly DistroBasedOn
        readonly PSUEDONAME
        readonly REV
        readonly KERNEL
        readonly MACH
    fi
fi

install_os ()
{
    UBUNTU_PACKAGE_NAME="$1"
    BIN_NAME="$2"
    # handle translations and special cases
    case $OS in
        Darwin)
            case $UBUNTU_PACKAGE_NAME in
                build-essential)
                    xcode-select --install || \
                        softwareupdate --install -a
                    return $?
                    ;;
                python-numpy)
                    install_tool pip numpy
                    install_tool pip3 numpy
                    return $?
                    ;;
                python-dev|python3-dev)
                    UBUNTU_PACKAGE_NAME="${UBUNTU_PACKAGE_NAME%-dev}"
                    ;;
                golang-go)
                    brew install go --cross-compile-common
                    return $?
                    ;;
                devscripts)
                    brew install "$BIN_NAME"
                    ;;
                *)
                    ;;
            esac
            set -- "$UBUNTU_PACKAGE_NAME" "$BIN_NAME"
            install_tool brew "$@"
            ;;
        Linux|*)
            install_tool apt "$@"
            ;;
    esac
    return 0
}

install_tool ()
{
    # - $2 is package name and required TODO assert that its set
    # - $3 is bin name (if your package adds multiple bins just pick one) and is
    #   optional, if not set it assumes bin name matches package name
    if [ "x$3" = "x" ]; then
        bin_name="$2"
    else
        bin_name="$3"
    fi

    if ! hash "$bin_name"; then
        case "$1" in
            brew)
                brew install "$2"
                ;;
            pip)
                sudo -H pip install "$2"
                ;;
            pip3)
                sudo -H pip3 install "$2"
                ;;
            apt)
                sudo -H apt-get -y install "$2"
                ;;
            *)
                echo "Unrecognized installer type"
                ;;
        esac
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
    OLD_SHELL="$SHELL"
    NEW_SHELL="$(type -p "$1")"
    if [ "$OLD_SHELL" != "$NEW_SHELL" ]; then
        chsh -s "$NEW_SHELL"
    fi
}

install_os zsh
switch_shell zsh

install_os keychain
install_os vim
# install_os rustc
# install_os cargo

# fzf
# ripgrep (hard because not in apt) (jk do it with cargo)

# compile ycm
# cd dotfiles/vim/bundle/vim-youcompleteme
# ./install --clang-completer
#     - look into installing bear to get completion on gcc projects
#     - Probably give up on clang completion, I dont think it worked on my
#       datalogic projects, but tags completion does!

# install_os cmake # redundant?
install_os cmake3 cmake
install_os build-essential
install_os python-dev python
install_os python3-dev python3
install_os python-pip pip
install_os python-numpy # I don't know how to check if numpy is installed
install_os golang-go

# static analysis checkers
install_os cppcheck
install_tool pip prospector
install_tool pip bashate
install_os devscripts checkbashisms # checkbashisms
# you have to enable trusty-backports on ubuntu 14.04 inorder to get this download to work
install_os shellcheck
