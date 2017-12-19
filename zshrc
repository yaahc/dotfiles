#! /bin/sh

echo "Sourcing .zshrc"

PROFILE_STARTUP=true
if [[ "$PROFILE_STARTUP" == true ]]; then
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>$HOME/tmp/startlog.$$
    setopt xtrace prompt_subst
fi

# Lines configured by zsh-newuser-install
export SAVEHIST=10000
setopt hist_ignore_all_dups
setopt inc_append_history
setopt share_history

# 10ms for key sequences
export KEYTIMEOUT=1

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

autoload -U colors && colors
autoload -U promptinit
promptinit

function precmd() {
    PROMPT="%n@%m>>"
}

if [ -d $FZF_DIR ] || hash fzf; then
    fzf-vim-file-widget() {
        # set -o xtrace

        # fuzzy search for file to edit
        edit_file="$(__fsel)"

        # if theres nothing clear the display and redisplay the terminal
        # immediately
        if [ ! -n "$edit_file" ]; then
            zle redisplay
            # I dont really know what return values from widgets matter for but
            # hey! ill return 1 randomly when I ctrl-c the fzf search
            return 1
        fi

        # shellcheck disable=SC2034
        BUFFER="vim $edit_file"
        local ret=$?
        # redraw the display to show what command is about to run
        zle redisplay
        # no idea what this does yet
        typeset -f zle-line-init >/dev/null && zle zle-line-init
        # run the command
        zle accept-line
        return $ret
    }

    zle     -N   fzf-vim-file-widget
    bindkey '^P' fzf-vim-file-widget
fi

fpath=(/usr/local/share/zsh-completions $fpath)

if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
fi
