export PS1="\[\e[1;30m\]\W:$ \[\e[m\]"
alias ll='ls -l'
alias rmback='rm *~'
alias xterm='xterm -sb -title xterm -e bash'
alias mv='mv -i'
alias cp='cp -i'
alias vi='vim'
alias ls='ls -F --color'
alias j='jobs'
alias menu='/google/data/ro/projects/menu/menu.par'
export EDITOR=vim
alias tmux='TERM=xterm-256color tmux'

# make up arrow search backward
bind '"\e[A"':history-search-backward
bind '"\e[B"':history-search-forward

#colors in the man pages
export LESS_TERMCAP_mb=$'\E[01;31m' # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m' # begin bold
export LESS_TERMCAP_me=$'\E[0m' # end mode
export LESS_TERMCAP_se=$'\E[0m' # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m' # begin standout-mode - info box export LESS_TERMCAP_ue=$'\E[0m' # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

#git config
source ~/.git-completion.bash
