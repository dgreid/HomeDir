export PS1="\[\e[1;30m\]\W:$ \[\e[m\]"
alias ll='ls -l'
alias rmback='rm *~'
alias xterm='xterm -sb -title xterm -e bash'
export PATH=~/scripts:~/bin:$PATH
alias mv='mv -i'
alias cp='cp -i'
alias vi='vim'
alias ls='ls -F --color'
alias e='emacsclient -c'
alias et='emacsclient -t'
alias j='jobs'
export EDITOR=vi
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
# for splint
export LARCH_PATH=/usr/local/splint-3.1.1/lib/
export LCLIMPORTDIR=/usr/local/splint-3.1.1/imports/
alias up='. ~/scripts/up'

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

#google p4 config
export P4CONFIG=.p4config
export P4DIFF=/home/build/public/google/tools/p4diff
export P4MERGE=/home/build/public/eng/perforce/mergep4.tcl 
export P4EDITOR=$EDITOR

alias cdg='cd /scratch/gtv-android'
