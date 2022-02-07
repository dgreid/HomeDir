#!/bin/sh
xset b off
xmodmap ~/.x_key_swap
xrdb -merge ~/.Xresources
exec /home/dylan/local/bin/dwm
