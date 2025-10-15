{ config, pkgs, pkgsUnstable, ... }:

{
  services.silverbullet = {
    enable = true;
    package = pkgsUnstable.silverbullet;
    user = config.myConfig.username;
    group = "users";
    spaceDir = "${config.myConfig.homeDir}/code/notes";
    listenAddress = "127.0.0.1";
    listenPort = 38157;
  };
}
