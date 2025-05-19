{ config, pkgs, pkgsUnstable, inputs, secrets, ... }:

{
  environment.systemPackages = [ pkgs.authelia ];

  systemd.services.authelia = {
    enable = true;
    serviceConfig = {
      ExecStart = "${pkgs.authelia}/bin/authelia --config /home/connor/code/infra/authelia/authelia-conf.yml";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };
}