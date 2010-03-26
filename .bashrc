export PS1='\[\e[0;37m\]\w(\#)$ \[\e[m\]'
alias ll='ls -l'
export GIBRALTAR_ROOT=:pserver:dr11423@gibraltar.bose.com:/home/epd/swrepository
export GABRIEL_ROOT=:pserver:dr11423@gabriel.bose.com:/cvsroot
export CVSROOT=:pserver:dr11423@epdpserver:2401/cvsroot
alias rmback='rm *~'
alias xterm='xterm -sb -fg green -bg black -title xterm -e bash'
export PATH=~/scripts:~/scripts/stlinux/:/opt/STM/STLinux-2.3/devkit/sh4/bin:$PATH
export PATH=/usr/local/ccache-bin/:/usr/local/gnu-arm/bin/:$PATH
export PATH=~/android/android-sdk-linux_86/tools/:$PATH
export PATH=/opt/java/bin:$PATH
export PATH=/usr/share/java/apache-ant/bin:$PATH
alias mv='mv -i'
alias cp='cp -i'
alias vi='vim'
alias ls='ls -F --color'
alias e='emacsclient -c'
alias et='emacsclient -t'
export EDITOR=vi
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export SVNROOT=svn+ssh://svn.bose.com/svn/hepd
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
