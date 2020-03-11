[[ $- == *i* ]] && fpath=(~/.scbuild/zsh_completions $fpath)

. $HOME/.shellrc

fpath=(~/.zfunc /usr/local/share/zsh-completions $fpath)

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

plugins=(
  zsh-autosuggestions
  cargo
)

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Lines configured by zsh-newuser-install
export SAVEHIST=10000
setopt hist_ignore_all_dups
setopt inc_append_history
setopt share_history

# 10ms for key sequences
export KEYTIMEOUT=1

bindkey -v
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

autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Color shortcuts
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh || $("$FZF_DIR/install" && source ~/.fzf.zsh)

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
        BUFFER="vim -O $edit_file"
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

if [ -f ~/.aliasrc ]; then
    . ~/.aliasrc
fi

if [ -d ~/.oh-my-zsh/custom/plugins ]; then
    if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/command-time ]; then
        git clone https://github.com/popstas/zsh-command-time.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/command-time
    fi
    if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
fi

if [ -f "$HOME/.scalerc_extras" ]; then
    . "$HOME/.scalerc_extras"
fi

if [ -f "$HOME/.scalerc_exports" ]; then
    . "$HOME/.scalerc_exports"
fi

EXERCISM_P="$HOME/exercism/bin/shell/exercism_completion.zsh"
[ -f $EXERCISM_P ] && source $EXERCISM_P

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

[ -f ~/.scbuild.zsh ] && source ~/.scbuild.zsh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export CFG_DISABLE_CROSS_TESTS=1

source /home/jlusby/.config/broot/launcher/bash/br

precmd() {
    export SC_CLAIMS="$(cat ~/.claims)"
    if [ -z "$SC_CLAIMS" ]; then
        unset SC_CLAIMS
    fi
}

export SC_CLAIMS=$(cat ~/.claims)

eval "$(starship init zsh)"
