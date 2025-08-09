{ config, lib, pkgs, ... }:

{
  services.navidrome = {
    enable = true;
    openFirewall = true;
    settings = {
      Address = "127.0.0.1";
      ReverseProxyWhitelist = "0.0.0.0/0";
      EnableUserEditing = false;
      Port = 15612;
      MusicFolder = "/scary/phone/music_library";
    };
  };
}
