let
  latestNixpkgs = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  latestPkgs = import latestNixpkgs { };
in
{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs.buildPackages; [
        autoconf
        automake
        bc
        binutils
        bison
        bzip2
        clang
        clang-tools
	crosvm
#	crosvm.buildInputs
#	crosvm.nativeBuildInputs
        curl
        flex
        gdb
        gitFull
        gnumake
        gnupg
        lynx
        ncurses
        neomutt
        latestPkgs.neovim
        nodejs
        openssh
        openvpn
        pass
        perf-tools
        pkgs.linuxPackages_latest.perf
        podman
	rustup
        tmux
        wget

# kernel builds
	#kernel.buildInputs
 perl gmp libmpc mpfr pkg-config ncurses perl bc nettools openssl rsync zstd python3 kmod
    ];
     # why do we need to set the library path manually?
    shellHook = ''
      export LIBCLANG_PATH="${pkgs.llvmPackages.libclang.lib}/lib";
    '';
}
