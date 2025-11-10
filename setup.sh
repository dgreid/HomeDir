#!/bin/sh
PWD=$(pwd)
for i in $(find . -maxdepth 1 -name '*[a-zA-Z]*' | grep -v setup.sh | grep -v '.git' | grep -v '.config' | grep -v '.ssh'); do
    rm -f ~/$i
    ln -s $PWD/$i ~/$i
done
ln -s $PWD/.git-completion.bash ~
ln -s $PWD/.gitconfig ~
mkdir -p ~/.ssh
ln -s $PWD/.ssh/config ~/.ssh/config
mkdir -p ~/.local/bin
mkdir -p ~/.config
ln -s ~/HomeDir/.config/lazyvim ~/.config/nvim
ln -s ~/HomeDir/.config/sway ~/.config/sway
ln -s ~/HomeDir/.config/ghostty ~/.config/ghostty
ln -s ~/HomeDir/.config/starship.toml ~/.config/starship.toml
mkdir -p ~/.local/share
ln -s ~/HomeDir/.local/share/i3status-rust ~/.local/share/
curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-linux -o ~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer
if [ -d ~/.tmux-sessions ]; then
    ln -s ~/HomeDir/.tmux-sessions ~
fi
if [ -d ~/.tmux-sessions-work ]; then
    ln -s ~/HomeDir/.tmux-sessions-work ~
fi
