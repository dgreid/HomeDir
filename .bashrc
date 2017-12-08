#ezprompt.net generated bash prompt
export PS1="\[\e[33m\]\W\[\e[m\]\[\e[33m\]\\$\[\e[m\] "
alias ll='ls -l'
alias mv='mv -i'
alias cp='cp -i'
alias ls='ls -F --color'
alias j='jobs'
export EDITOR=vim
alias tmux='TERM=xterm-256color tmux'

# make up arrow search backward
bind '"\C-p":history-search-backward'
bind '"\C-n":history-search-forward'

#colors in the man pages
export LESS_TERMCAP_mb=$'\E[01;31m' # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m' # begin bold
export LESS_TERMCAP_me=$'\E[0m' # end mode
export LESS_TERMCAP_se=$'\E[0m' # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m' # begin standout-mode - info box export LESS_TERMCAP_ue=$'\E[0m' # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

export PATH=$PATH:~/bin:~/.cargo/bin

#git config
source ~/.git-completion.bash
