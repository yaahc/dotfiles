#! /bin/sh

. $HOME/.shellrc

PROFILE_STARTUP=true
if [[ "$PROFILE_STARTUP" == true ]]; then
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>$HOME/tmp/startlog.$$
    setopt xtrace prompt_subst
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME=""

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

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

# Gets the difference between the local and remote branches
function git_remote_status() {
    local remote ahead behind git_remote_status git_remote_status_detailed
    remote=${$(command git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
    if [[ -n ${remote} ]]; then
        ahead=$(command git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
        behind=$(command git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)

        if [[ $ahead -gt 0 ]] && [[ $behind -eq 0 ]]; then
            git_remote_status="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))%{$reset_color%}"
        fi
        if [[ $behind -gt 0 ]] && [[ $ahead -eq 0 ]]; then
            git_remote_status="$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))%{$reset_color%}"
        fi

        echo $git_remote_status
    fi
}

# Color shortcuts
RED=$fg[red]
YELLOW=$fg[yellow]
GREEN=$fg[green]
WHITE=$fg[white]
BLUE=$fg[blue]
RED_BOLD=$fg_bold[red]
YELLOW_BOLD=$fg_bold[yellow]
GREEN_BOLD=$fg_bold[green]
WHITE_BOLD=$fg_bold[white]
BLUE_BOLD=$fg_bold[blue]
RESET_COLOR=$reset_color

local ret_status="%(?:%{$GREEN%}%c:%{$RED%}%c)"
# # PROMPT='${ret_status}%{$fg[green]%} %{$fg[blue]%}$(git_prompt_info)%{$fg[blue]%}$(git_commits_ahead)$(git_commits_behind)%{$fg[green]%}>>%{$reset_color%}'
PROMPT='${ret_status}%{$GREEN%} %{$BLUE%}$(git_prompt_info)%{$BLUE%}$(git_remote_status)%{$YELLOW%}$(git_prompt_status)%{$GREEN%}>>%{$reset_color%}'

# ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}["
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%}${git_commits_ahead}${git_commits_behind}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$YELLOW%} ✗"
ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX=" |+"
ZSH_THEME_GIT_COMMITS_BEHIND_PREFIX=" |-"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=" |+"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE=" |-"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR="%{$YELLOW%}"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR="%{$YELLOW%}"
# ZSH_THEME_GIT_PROMPT_UNTRACKED="u"
# ZSH_THEME_GIT_PROMPT_ADDED="a"
# ZSH_THEME_GIT_PROMPT_MODIFIED="m"
# ZSH_THEME_GIT_PROMPT_RENAMED="r"
# ZSH_THEME_GIT_PROMPT_DELETED="d"
ZSH_THEME_GIT_PROMPT_STASHED="|stashed"
ZSH_THEME_GIT_PROMPT_UNMERGED="|unmerged"
# ZSH_THEME_GIT_PROMPT_AHEAD="+"
# ZSH_THEME_GIT_PROMPT_BEHIND="-"
# ZSH_THEME_GIT_PROMPT_DIVERGED="~"

# git remote status
ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE="="
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="+"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="-"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="+&&-"
ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_DETAILED="yes"

# # Format for git_prompt_info()
# ZSH_THEME_GIT_PROMPT_PREFIX=""
# ZSH_THEME_GIT_PROMPT_SUFFIX=""

# # Format for parse_git_dirty()
# # ZSH_THEME_GIT_PROMPT_DIRTY=" %{$RED%}(*)"
# # ZSH_THEME_GIT_PROMPT_CLEAN=""

# # Format for git_prompt_status()
# ZSH_THEME_GIT_PROMPT_UNMERGED=" %{$RED%}unmerged"
# ZSH_THEME_GIT_PROMPT_DELETED=" %{$RED%}deleted"
# ZSH_THEME_GIT_PROMPT_RENAMED=" %{$YELLOW%}renamed"
# ZSH_THEME_GIT_PROMPT_MODIFIED=" %{$YELLOW%}modified"
# ZSH_THEME_GIT_PROMPT_ADDED=" %{$GREEN%}added"
# ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$WHITE%}untracked"

# # Format for git_prompt_ahead()
# ZSH_THEME_GIT_PROMPT_AHEAD="%{$RED%}+"
# ZSH_THEME_GIT_PROMPT_BEHIND="%{$RED%}-"

# # Format for git_prompt_long_sha() and git_prompt_short_sha()
# ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$WHITE%}[%{$YELLOW%}"
# ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$WHITE%}]"

# # Prompt format
# PROMPT='
# %{$GREEN%}%n@%m%{$WHITE%}:%{$YELLOW%}%~%u$(parse_git_dirty)$(git_prompt_ahead)$(git_prompt_behind)%{$RESET_COLOR%}
# %{$BLUE%}>%{$RESET_COLOR%} '
# RPROMPT='%{$GREEN%}$(git_current_branch)$(git_prompt_short_sha)$(git_prompt_status)%{$RESET_COLOR%}'
# PROMPT='%n@%m>>'

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

fpath=(/usr/local/share/zsh-completions $fpath)

if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
fi

if [ -f ~/.aliasrc ]; then
    . ~/.aliasrc
fi

. "$HOME/.scalerc"

# if [ -f $(which powerline-daemon) ]; then
#     . /usr/share/powerline/zsh/powerline.zsh
# fi

# if [ "$TERM" != "screen" ] && [ "$TERM" != "screen-256color" ]; then
#     tmux attach -t Dev
# fi
