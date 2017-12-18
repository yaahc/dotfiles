#! /bin/sh

if [ -e "$BSPWM_TREE" ] ; then
    bspc restore -T "$BSPWM_TREE" -H "$BSPWM_HISTORY" -S "$BSPWM_STACK"
    rm "$BSPWM_TREE" "$BSPWM_HISTORY" "$BSPWM_STACK"
fi

export PATH=$HOME/Scripts:$HOME/seahawk/bin:$PATH:/opt/java/bin:$HOME/.cargo/bin

export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
if [ -z "$VISUAL" ]; then
    VISUAL=nvim
fi

if [ "$VISUAL" = "nvim" ]; then
    if [ -e /tmp/nvimsocket ]; then
        export VISUAL='nvr -cc vsplit -s'
    fi
    export VIMCONFIG=~/.config/nvim
    export VIMDATA=~/.local/share/nvim
else
    export VIMCONFIG=~/.vim
    export VIMDATA=~/.vim
fi
alias vim="$VISUAL"

# Lines configured by zsh-newuser-install
export HISTFILE=~/.history
export HISTSIZE=10000
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

export LC_ALL="C"
if [ -x /usr/bin/dircolors ]; then
    # GNU cli color config
    if test -r ~/.dircolors; then eval "$(dircolors -b ~/.dircolors)"; else eval "$(dircolors -b)"; fi
    alias ls='ls --color=auto --group-directories-first -l'
    alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    export LESS="-R"
    export GREP_OPTIONS='--color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
else
    alias ls="/usr/local/bin/gls --color -h --group-directories-first"
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
fi

# some more ls aliases
alias open="xdg-open"

#random Aliases
alias pianobar="pianobar | tee ~/.piano_lines.out"

autoload -U colors && colors
autoload -U promptinit
promptinit

function precmd() {
    PROMPT="%n@%m>>"
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

export XDG_CONFIG_HOME="$HOME/.config"

if hash keychain > /dev/null 2>&1; then
    eval "$(keychain --eval --quiet id_rsa id_ed25519 build_dsa build_rsa > /dev/null 2>&1)"
fi

# if [ -f "${HOME}/.gpg-agent-info" ]; then
#     . "${HOME}/.gpg-agent-info"
#     export GPG_AGENT_INFO
#     export SSH_AUTH_SOCK
# fi

# SSH_AUTH_SOCK=`ss -xl | grep -o '/run/user/1000/keyring-.*/ssh'`
# [ -z "$SSH_AUTH_SOCK" ] || export SSH_AUTH_SOCK


FZF_DIR="$HOME/dotfiles/vim/bundle/fzf/bin/"
if [ -d $FZF_DIR ] || hash fzf; then
    export PATH=$PATH:$FZF_DIR
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh || $("$FZF_DIR/install" && source ~/.fzf.zsh)
    if hash rg 2> /dev/null; then
        export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden -g "!{.git,node_modules}/*" 2> /dev/null'
    fi
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_CTRL_T_OPTS="--select-1 --exit-0 --reverse"
    if hash bfs 2> /dev/null; then
        export FZF_ALT_C_COMMAND="if [ -e ~/.bfs.cache ]; then cat ~/.bfs.cache; else bfs ~/ -type d -nohidden; fi"
        alias update-altc='bfs ~/ -type d -nohidden > ~/.bfs.cache'
    fi
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

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

if [ "$TERM" != "screen" ]; then
    tmux attach -t Dev
fi

. "$HOME/dotfiles/scalerc"
