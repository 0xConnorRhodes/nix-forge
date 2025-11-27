{ config, pkgs, pkgsUnstable, ... }:

{
  services.silverbullet = {
    enable = true;
    package = pkgs.silverbullet;
    user = config.myConfig.username;
    group = "users";
    spaceDir = "${config.myConfig.homeDir}/.local/notes/silverbullet";
    listenAddress = "127.0.0.1";
    listenPort = 38157;
  };
}
