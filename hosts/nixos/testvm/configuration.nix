{ config, lib, pkgs, inputs, secrets, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./secret.nix
    ../../common/host-options.nix
    ../../common/nixos-common.nix
    inputs.home-manager.nixosModules.default
    inputs.nix-index-database.nixosModules.nix-index
  ];

  config = {
    myConfig = {
      hostname = "testvm";
      username = "connor";
      homeDir = "/home/connor";
      trashcli = "trash";
      modAlt = "ctrl";
      modCtrl = "alt";
      hostPaths = [];
    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "testvm";
    networking.networkmanager.enable = true;

    users.users.${config.myConfig.username} = {
      isNormalUser = true;
      description = "Connor Rhodes";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFRNR1Ee12nbxJcXbzhq6WUkkGn8mADvtRERAs3ufLOK"
      ];
    };

    home-manager.users.${config.myConfig.username} = { pkgs, ... }: {
      home.stateVersion = "25.11";
      imports = [ ./home.nix ];
    };

    system.stateVersion = "25.11";
  };
}
