{ config, pkgs, pkgsUnstable, ... }:

{
  services.silverbullet = {
    enable = true;
    package = pkgs.silverbullet;
    user = config.myConfig.username;
    group = "users";
    spaceDir = "${config.myConfig.homeDir}/code/notes";
    listenAddress = "127.0.0.1";
    listenPort = 38157;
  };

  systemd.services.silverbullet.serviceConfig.Environment =
    [ "SB_SPACE_IGNORE=Inbox/voice_notes" ];
}
