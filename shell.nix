let
  latestNixpkgs = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  latestPkgs = import latestNixpkgs { };
in
{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs.buildPackages; [
        bc
#	crosvm.buildInputs
#	crosvm.nativeBuildInputs
	delta
        fzf
        gitFull
        gnumake
        gnupg
	meson
        ncurses
        neomutt
        latestPkgs.neovim
        nodejs
        openssh
        pass
	rustup
        tmux
        wget

    ];
}
