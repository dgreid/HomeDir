#!/bin/sh
xscreensaver &
xset b off
xmodmap ~/.x_key_swap
xrdb -merge ~/.Xresources
exec /usr/bin/dwm
