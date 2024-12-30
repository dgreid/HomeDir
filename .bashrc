#ezprompt.net generated bash prompt
export PS1="\[\e[36m\]\W\[\e[m\]\[\e[36m\]\\$\[\e[m\] "
alias ll='ls -l'
alias mv='mv -i'
alias cp='cp -i'
alias ls='ls -F --color'
alias j='jobs'
export EDITOR=nvim

#if rivos is in the hostname, export the work srcpath.
if [[ $(hostname) == *rivosinc* ]]; then
    export SRC_PATH=/scratch
else
    export SRC_PATH=~/src
fi

# make up arrow search backward
bind '"\C-p":history-search-backward'
bind '"\C-n":history-search-forward'

#colors in the man pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box export LESS_TERMCAP_ue=$'\E[0m' # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

export PATH=~/local/bin:~/.cargo/bin:$PATH:~/.local/bin:/opt/riscv/bin

set bell-style none

#git config
source ~/.git-completion.bash

#iterm2 integration
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash" || true

export MOSH_ESCAPE_KEY=""
