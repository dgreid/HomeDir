xset b off
xscreensaver -no-splash &
emacs --daemon
~/scripts/setroottotime.sh &
~/scripts/rundwm.sh
