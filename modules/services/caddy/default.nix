{ config, pkgs, pkgsUnstable, inputs, secrets, ... }:

let
  autheliaSSO = ''
    forward_auth 127.0.0.1:9091 {
      uri /api/verify?rd=https://auth.connorrhodes.com
      copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
    }
  '';

  autheliaSSODotEngineer = ''
    forward_auth 127.0.0.1:9092 {
      uri /api/verify?rd=https://auth.connor.engineer
      copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
    }
  '';

  robotsTxt = ''
    @robots path /robots.txt
    handle @robots {
      respond 200 {
        body "User-agent: *\nDisallow: /"
      }
    }
  '';

  connorrhodesCom = import ./connorrhodes-com.nix { inherit secrets autheliaSSO robotsTxt; };
  rhodesContact = import ./rhodes-contact.nix { };
  connorEngineer = import ./connor-engineer.nix { inherit autheliaSSODotEngineer robotsTxt; };
  redirects = import ./redirects.nix { };
in
{
  services.caddy = {
    enable = true;
    package = pkgs.caddy;

    globalConfig = ''
      email ${secrets.caddy.email}
    '';

    virtualHosts = connorrhodesCom.virtualHosts // rhodesContact.virtualHosts // connorEngineer.virtualHosts // redirects.virtualHosts;
  };

  fileSystems."/var/www/bootstrap" = {
    device = "/home/connor/code/scripts/bootstrap";
    options = [ "bind" "X-nosuid" "X-nodev" "X-noexec" ];
  };
  fileSystems."/var/www/demo_notes" = {
    device = "/home/connor/code/demo-notes-connor-engineer/build";
    options = [ "bind" "X-nosuid" "X-nodev" "X-noexec" ];
  };
  fileSystems."/var/www/search" = {
    device = "/home/connor/code/my-unduck/dist";
    options = [ "bind" "X-nosuid" "X-nodev" "X-noexec" ];
  };

  users.groups.users.members = [ "caddy" ];
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
