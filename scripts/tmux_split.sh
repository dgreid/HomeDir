#!/usr/bin/env bash

# Get the current width of the terminal.
width=$(tmux display-message -p '#{pane_width}')

# If the widths is less than 3, exit.
if [ $width -lt 3 ]; then
    echo "Terminal is too narrow."
    exit 1
fi

# The default center width is 106 if width < 220, otherwise 212.
if [ $width -lt 220 ]; then
    default_width=106
else
    default_width=212
fi

# First argument to the script is the center pane width.
# If no argument is given, the default is 106.
center_width=${1:-$default_width}

# left and right must each be at least 1. If center is too wide, set it to the total width -2.
if [ $center_width -gt $((width - 2)) ]; then
    center_width=$((width - 2))
fi

side_width=$(((width - center_width) / 2))

# Split the current pane into three panes.
tmux split-window -h -l $side_width
tmux split-window -h -l $center_width -t 0
tmux select-pane -t 1
