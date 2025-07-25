#!/usr/bin/env bash
# from github.com/theprimeagen/tmux-sessionizer

switch_to() {
    if [[ -z $TMUX ]]; then
        tmux attach-session -t $1
    else
        tmux switch-client -t $1
    fi
}

has_session() {
    tmux list-sessions | grep -q "^$1:"
}

hydrate() {
    if [ -f $2/.tmux-sessionizer ]; then
        tmux send-keys -t $1 "source $2/.tmux-sessionizer" c-M
    elif [ -f $HOME/.tmux-sessionizer ]; then
        tmux send-keys -t $1 "source $HOME/.tmux-sessionizer" c-M
    elif [ -f $HOME/.tmux-sessions/$selected_name ]; then
        tmux send-keys -t $1 "source $HOME/.tmux-sessions/$selected_name" c-M
    elif [ -f $HOME/.tmux-sessions-work/$selected_name ]; then
        tmux send-keys -t $1 "source $HOME/.tmux-sessions-work/$selected_name" c-M
    else
        tmux send-keys -t $1 "source $HOME/scripts/tmux_split.sh $2" c-M
        tmux rename-window -t $1 $selected_name
    fi
}

if [[ $# -eq 1 ]]; then
    selected=$1
else
    # If someone wants to make this extensible, i'll accept
    # PR
    selected=$(find ~/ ~/src /scratch -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    hydrate $selected_name $selected
    exit 0
fi

if ! has_session $selected_name; then
    tmux new-session -ds $selected_name -c $selected
    hydrate $selected_name $selected
fi

switch_to $selected_name
