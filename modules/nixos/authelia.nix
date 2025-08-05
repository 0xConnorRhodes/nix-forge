{ config, lib, pkgs, pkgsUnstable, inputs, secrets, ... }:

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

  services.redis = {
    servers.authelia = {
      enable = true;
      settings = {
        bind = "127.0.0.1";
        port = lib.mkForce 6385;
      };
    };
  };
}
