{ config, pkgs, pkgsUnstable, inputs, secrets, ... }:
let
  #myCaddy = pkgsUnstable.caddy.withPlugins {
  #  # list of plugins
  #  plugins = [
  #    "github.com/caddy-dns/cloudflare@v0.2.1"
  #  ];
  #  # resulting hash of binary built with all plugins
  #  hash = "sha256-saKJatiBZ4775IV2C5JLOmZ4BwHKFtRZan94aS5pO90=";
  #};
  myCaddy = pkgs.caddy;
in 
{
  environment.systemPackages = [ myCaddy ];
  networking.firewall.allowedTCPPorts = [ 80 443];

  systemd.services.caddy = {
    enable = true;
    serviceConfig = {
      ExecStart = "${myCaddy}/bin/caddy run --config /home/connor/code/infra/caddy/Caddyfile";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
