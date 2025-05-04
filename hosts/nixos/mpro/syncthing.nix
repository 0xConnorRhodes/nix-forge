{ pkgs, config, ... }:
let
  guiPort = 42631;
in
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    key = "${config.myConfig.homeDir}/code/nix-forge/hosts/nixos/mpro/config/syncthing-key.pem";
    cert = "${config.myConfig.homeDir}/code/nix-forge/hosts/nixos/mpro/config/syncthing-cert.pem";
    guiAddress = "${config.myConfig.tailscaleIp}:${toString guiPort}";
    settings.gui = {
      user = "";
      password = "";
    };
  };
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder
}