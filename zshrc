#! /bin/sh

if [ -e "$BSPWM_TREE" ] ; then
	bspc restore -T "$BSPWM_TREE" -H "$BSPWM_HISTORY" -S "$BSPWM_STACK"
	rm "$BSPWM_TREE" "$BSPWM_HISTORY" "$BSPWM_STACK"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=2000
bindkey -v
#bindkey "^K" history-search-backward
#bindkey "^J" history-search-forward
bindkey '^R' history-incremental-search-backward
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/jlusby/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto --group-directories-first'
    alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    export LESS="-R"
    export GREP_OPTIONS='--color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep -nE'
alias todo='todo -G +children'
alias rbupdate="rbt post -p --server http://reviewboard.dl.net/codereview -r"
alias rbreview="~/svn/evolution-build/scripts/rbreview.sh"
alias open="xdg-open"
alias slpsearch="slptool findsrvs LanehawkCamera"

#random Aliases
alias pianobar='pianobar | tee ~/.piano_lines.out'

autoload -U colors && colors
autoload -U promptinit
promptinit

parse_git_branch () {
    git branch 2> /dev/null | grep "*" | sed -e 's/* \(.*\)/\1/g'
}

function precmd() {
    PROMPT="%n@%m>>"
    # TEST_BRANCHNAME_STRING=$(parse_git_branch)
    # if [ -n "$TEST_BRANCHNAME_STRING" ] ; then
    #     RPROMPT="[%{$fg_no_bold[cyan]%}$TEST_BRANCHNAME_STRING%{$reset_color%}][%{$fg_no_bold[green]%}%~%{$reset_color%}]"
    # else
    # RPROMPT="[%30<...<%{$fg_no_bold[green]%}%~%{$reset_color%}%<<]"
    # RPROMPT="[%{$fg_no_bold[green]%}%~%{$reset_color%}]"
    # fi
}

[ -n "$XTERM_VERSION" ] && transset-df .9 -a >/dev/null
#use solarized ls colors
#eval $(dircolors ~/.dir_colors)

# colorful man pages
export LESS_TERMCAP_mb=$'\E[31m'
export LESS_TERMCAP_md=$'\E[31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[1;40;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[32m'

export EDITOR=/usr/bin/vim

export PRU_CGT=/home/jlusby/ti/ccsv6/tools/compiler/ti-cgt-pru_2.1.1/
export ARM_CGT=/home/jlusby/ti/ccsv6/tools/compiler/ti-cgt-arm_5.2.2/
export SW_DIR=/home/jlusby/starterwarefree-code/

export SVNUSER=jlusby

export PATH=$HOME/Scripts:$HOME/seahawk/bin:$PATH:/opt/java/bin
# export SHCC=$HOME/sdks/ti-processor-sdk-linux-am57xx-evm-02.00.01.07/linux-devkit/sysroots/x86_64-arago-linux/usr/bin/arm-linux-gnueabihf-

export XDG_CONFIG_HOME="$HOME/.config"

eval $(keychain --eval --quiet id_rsa id_ed25519)

# if [ -f "${HOME}/.gpg-agent-info" ]; then
#     . "${HOME}/.gpg-agent-info"
#     export GPG_AGENT_INFO
#     export SSH_AUTH_SOCK
# fi

# SSH_AUTH_SOCK=`ss -xl | grep -o '/run/user/1000/keyring-.*/ssh'`
# [ -z "$SSH_AUTH_SOCK" ] || export SSH_AUTH_SOCK

sssh(){
    # try to connect every 0.5 secs (modulo timeouts)
    while true; do command ssh "$@"; [ $? -eq 0 ] && break || sleep 0.5; done
}

trynet(){
    # try to connect every 0.5 secs (modulo timeouts)
    while true; do command telnet "$@"; [ $? -eq 0 ] && break || sleep 0.5; done
}


alias uselocal='export DEV_ILCU_ADDR="`~/seahawk/app/lanehawk/tools/XmlStatusParser/XmlStatusParser.py`"; echo "Using: $DEV_ILCU_ADDR"'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_DEFAULT_COMMAND='rg --files -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="cd ~/; bfs -type d -nohidden | sed s/^\./~/"
