{ config, lib, pkgs, pkgsUnstable, inputs, secrets, ... }:

{
  environment.systemPackages = [ pkgs.authelia ];

  # First Authelia instance (connorrhodes.com)
  systemd.services.authelia-connorrhodes-com = {
    enable = true;
    after = [ "redis-authelia.service" ];
    wants = [ "redis-authelia.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.authelia}/bin/authelia --config /home/connor/code/infra/authelia/conf-connorrhodes-com.yml";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # Second Authelia instance (connor-engineer)
  systemd.services.authelia-connor-engineer = {
    enable = true;
    after = [ "redis-authelia.service" ];
    wants = [ "redis-authelia.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.authelia}/bin/authelia --config /home/connor/code/infra/authelia/conf-connor-engineer.yml";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };

  services.redis = {
    servers.authelia = {
      enable = true;
      appendOnly = true; # persist data on disk
      settings = {
        bind = "127.0.0.1";
        port = lib.mkForce 6385;
      };
    };
  };
}
