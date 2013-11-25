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
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/jlusby/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -X --color=auto --group-directories-first'
    alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    export LESS="-R"
    export GREP_OPTIONS='--color=auto'
    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

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
    TEST_BRANCHNAME_STRING=$(parse_git_branch)
    if [ -n "$TEST_BRANCHNAME_STRING" ] ; then
        RPROMPT="[%{$fg_no_bold[cyan]%}$TEST_BRANCHNAME_STRING%{$reset_color%}][%{$fg_no_bold[green]%}%~%{$reset_color%}]"
    else
        RPROMPT="[%{$fg_no_bold[green]%}%~%{$reset_color%}]"
    fi
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


if [ -f "${HOME}/.gpg-agent-info" ]; then
    . "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
fi
