{ pkgs, modulesPath, lib, ... }: {
  imports = [
    "${modulesPath}/installer/cd-dvd/iso-image.nix"
  ];

  # use the latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Needed for https://github.com/NixOS/nixpkgs/issues/58959
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];

  boot.initrd.availableKernelModules = [ "virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio" ];
  boot.initrd.kernelModules = [ "virtio_net" "virtio_console" "virtio_rng" "9p" "9pnet_virtio" ];

  networking.hostName = "mbpnix";

  # no need for grub menu
  boot.loader.timeout = lib.mkForce 0;

  # Start the ssh server
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  # Create a user
  users.users.dgreid = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBMu/0O6PtVg+8SAynHa2h4GG/XwOpX9ZASIjZIsS+Gg dylanreid"
    ];
  };

  security.sudo.extraRules= [
  {
    users = [ "dgreid" ];
    commands = [
    {
      command = "ALL" ;
      options= [ "NOPASSWD" ];
    }
    ];
  }
  ];

  # CLI tools, language runtimes, shells, and other desired packages
  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    openssl
    neovim
    tmux
  ];
}
