{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.pairdrop
  ];

  systemd.services.pairdrop = {
    enable = true;
    serviceConfig = {
      ExecStart = "${pkgs.pairdrop}/bin/pairdrop";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
