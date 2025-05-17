{ config, pkgs, pkgsUnstable, inputs, secrets, ... }:
let
  # certsDir = config.myConfig.homeDir + "/.local/certs/cf_origin_certs/";
  # certsDir = "/var/certs/cf_origin_certs/";

  myCaddy = pkgsUnstable.caddy.withPlugins {
    # list of plugins
    plugins = [
      "github.com/caddy-dns/cloudflare@v0.2.1"
    ];
    # resulting hash of binary built with all plugins
    hash = "sha256-saKJatiBZ4775IV2C5JLOmZ4BwHKFtRZan94aS5pO90=";
  };
in 
{
  environment.systemPackages = [ myCaddy ];
  networking.firewall.allowedTCPPorts = [ 80 443];

  config = {
    environment.etc = {
      "caddy/Caddyfile".text = ''
        :80 {
          respond "hello, world" 
        }
      '';
    };
  };


    systemd.services.caddy = {
      enable = true;
      serviceConfig = {
        ExecStart = "${myCaddy}/bin/caddy run --config /etc/caddy/Caddyfile";
        Restart = "always";
      };
      wantedBy = [ "multi-user.target" ];
    };

  # systemd.services.caddy = {
  #   serviceConfig = {
  #     Type = "notify";
  #     User = "connor";
  #     Group = "users";
  #     #ExecStart = "${myCaddy}/bin/caddy run --config /home/connor/code/caddy/Caddyfile";
  #     ExecStart = "${myCaddy}/bin/caddy --help";
  #     TimeoutStopSec = "5s";
  #     Restart = "always";
  #     RestartSec = "5s";
  #     # WorkingDirectory = "/home/connor/code/caddy";
  #     # Environment = "PATH=${pkgs.iputils}/bin:${pkgs.git}/bin:${pkgs.openssh}/bin:$PATH"; 
  #   }; 
  # };
}