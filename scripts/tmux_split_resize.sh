#!/usr/bin/env bash

# Get the current width of the terminal.
width=$(tmux display-message -p '#{window_width}')

# If the widths is less than 3, exit.
if [ $width -lt 3 ]; then
    exit 0
fi

# if there aren't three panes, exit.
if [ $(tmux list-panes | wc -l) -ne 3 ]; then
    exit 0
fi

# The default center width is 106 if width < 220, otherwise 212.
if [ $width -lt 220 ]; then
    center_width=106
else
    center_width=212
fi

# left and right must each be at least 1. If center is too wide, set it to the total width -2.
if [ $center_width -gt $((width - 2)) ]; then
    center_width=$((width - 2))
fi

side_width=$(((width - center_width) / 2))

tmux resize-pane -x $side_width -t 2
tmux resize-pane -x $side_width -t 0
