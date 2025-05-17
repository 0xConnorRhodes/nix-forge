{ config, pkgs, pkgsUnstable, inputs, secrets, ... }:
let
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
  # ensures the same caddy can be run interactively
  environment.systemPackages = [ myCaddy ];

  services.caddy = {
    enable = true;
    package = myCaddy;
    email = secrets.userInfo.email;

    virtualHosts = {
      ":80".extraConfig = ''
        respond "Hello, world"
      '';
      # "jf.connorrhodes.com".extraConfig = ''
      #   reverse_proxy 127.0.0.1:8096
      # '';
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443];
}