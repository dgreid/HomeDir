#!/usr/bin/env bash

# if the first argument is given, set CDDIR to '-c argument'
if [ -n "$1" ]; then
    CDDIR="-c $1"
else
    CDDIR=""
fi

# Get the current width of the terminal.
width=$(tmux display-message -p '#{window_width}')

# If the widths is less than 3, exit.
if [ $width -lt 3 ]; then
    echo "Terminal is too narrow."
    exit 1
fi

# if there are more than one panes, exit.
if [ $(tmux list-panes | wc -l) -gt 1 ]; then
    echo "There are already multiple panes."
    exit 1
fi

# Split the current pane into three panes.
tmux split-window -h $CDDIR
tmux split-window -h $CDDIR
~/scripts/tmux_split_resize.sh
tmux select-pane -t 1
