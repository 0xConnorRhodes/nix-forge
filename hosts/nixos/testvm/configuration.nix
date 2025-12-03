{ config, lib, pkgs, inputs, secrets, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ../../common/host-options.nix
    ../../common/nixos-common.nix
  ];

  config = {
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/vda";
    boot.loader.grub.useOSProber = true;

    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "testvm";
    networking.networkmanager.enable = true;

    security.sudo.wheelNeedsPassword = false;

    users.users.${config.myConfig.username} = {
      isNormalUser = true;
      description = "Connor Rhodes";
      extraGroups = [ "networkmanager" "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFRNR1Ee12nbxJcXbzhq6WUkkGn8mADvtRERAs3ufLOK"
      ];
    };

    system.stateVersion = "25.11";
  };
}
