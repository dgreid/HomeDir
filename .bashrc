# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# basic shell
HISTCONTROL=ignoreboth
HISTSIZE=32768
HISTFILESIZE="${HISTSIZE}"

# set source directory for git repos

if [[ -d /scratch ]]; then
    export SRC_PATH=/scratch
else
    export SRC_PATH=$HOME/src
fi

## Autocompletion
if [[ ! -v BASH_COMPLETION_VERSINFO && -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi

## Ensure command hashing is off for mise
set +h

# File system
if command -v eza &>/dev/null; then
    alias ls='eza -lh --group-directories-first --icons=auto'
    alias lsa='ls -a'
    alias lt='eza --tree --level=2 --long --icons --git'
    alias lta='lt -a'
else
    alias ls='ls -F --color'
fi

alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

if command -v zoxide &>/dev/null; then
    alias cd="zd"
    zd() {
        if [ $# -eq 0 ]; then
            builtin cd ~ && return
        elif [ -d "$1" ]; then
            builtin cd "$1"
        else
            z "$@" && printf "\U000F17A9 " && pwd || echo "Error: Directory not found"
        fi
    }
fi

open() {
    xdg-open "$@" >/dev/null 2>&1 &
}

# prompt
force_color_prompt=yes
color_prompt=yes

## Simple prompt with path in the window/pane title and caret for typing line
## will overrid ewith spaceship if available
export PS1=$'\uf0a9 '
export PS1="\[\e[36m\]\W\[\e[m\]\[\e[36m\] $PS1\[\e[m\] "
if [[ -z "$TMUX" ]]; then
    # Not in tmux → show @host
    PS1="\[\e[01;32m\]@\h\[\e[00m\]:$PS1"
fi

# helpers
if command -v mise &>/dev/null; then
    eval "$(mise activate bash)"
fi

if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi

if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
fi

if command -v fzf &>/dev/null; then
    if [[ -f /usr/share/fzf/completion.bash ]]; then
        source /usr/share/fzf/completion.bash
    fi
    if [[ -f /usr/share/fzf/key-bindings.bash ]]; then
        source /usr/share/fzf/key-bindings.bash
    fi
fi

# env
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export BAT_THEME=ansi

# input
set meta-flag on
set input-meta on
set output-meta on
set convert-meta off
set completion-ignore-case on
set completion-prefix-display-length 2
set show-all-if-ambiguous on
set show-all-if-unmodified on

# history search for what has been written
bind '"\C-p":history-search-backward'
bind '"\C-n":history-search-forward'

# Immediately add a trailing slash when autocompleting symlinks to directories
set mark-symlinked-directories on

# Do not autocomplete hidden files unless the pattern explicitly begins with a dot
set match-hidden-files off

# Show all autocomplete results at once
set page-completions off

# If there are more than 200 possible completions for a word, ask to show them all
set completion-query-items 200

# Show extra file information when completing, like `ls -F` does
set visible-stats on

# Be more intelligent when autocompleting by also looking at the text after
# the cursor. For example, when the current line is "cd ~/src/mozil", and
# the cursor is on the "z", pressing Tab will not autocomplete it to "cd
# ~/src/mozillail", but to "cd ~/src/mozilla". (This is supported by the
# Readline used by Bash 4.)
set skip-completed-text on

# Coloring for Bash 4 tab completions.
set colored-stats on
. "$HOME/.cargo/env"
export PATH="$HOME/.local/bin:$PATH"
