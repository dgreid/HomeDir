source ~/.bashrc

. "$HOME/.cargo/env"

if [ -e /home/dylan/.nix-profile/etc/profile.d/nix.sh ]; then . /home/dylan/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
