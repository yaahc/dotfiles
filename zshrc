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

#ls aliases
alias la="ls --group-directories-first -AFX"

alias ls="ls --color=auto"
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
