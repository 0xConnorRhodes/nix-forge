{ config, lib, pkgs, ... }:

{
  imports = [
    ../../common/plasma-common.nix
  ];

  hardware.bluetooth.enable = true;
  environment.systemPackages = with pkgs; [
    kdePackages.bluedevil
  ];

  home-manager.users.${config.myConfig.username} = { pkgs, ... }: {
    home.stateVersion = "24.11";
    # programs.plasma = {
    #   enable = true;
    #   workspace = {
    #     clickItemTo = "open";
    #   };
    # };
  };
}
