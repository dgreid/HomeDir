#!/bin/sh
while true; do
  # Log stderror to a file 
  #dwm 2> ~/.dwm.log
  # No error logging
    ~/scripts/setroottotime.sh &
    ~/bin/dwm >/dev/null 2>&1
done
