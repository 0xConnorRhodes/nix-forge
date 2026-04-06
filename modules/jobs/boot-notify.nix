{ config, lib, pkgs, ... }:
let
  user = config.myConfig.username;
  pushcli-src = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/markus-perl/pushover-cli/master/pushover-cli";
    hash = "sha256-DmNwkv58Bt3rwL5hEaWKMGP8LCoibVQKPkTyyyH07k4=";
  };
  pushcli = pkgs.writeShellScriptBin "pushcli" ''
    exec ${pkgs.python3}/bin/python3 ${pushcli-src} "$@"
  '';
in
{
  sops = {
    age.keyFile = "/home/${user}/.config/sops/age/keys.txt";
    defaultSopsFile = ./../../secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets."pushcli/user" = { };
    secrets."pushcli/token" = { };
  };

  systemd.services."boot-notify" = {
    after = [ "multi-user.target" "sops-nix.service" ];
    wants = [ "sops-nix.service" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      pushcli_user=$(cat ${config.sops.secrets."pushcli/user".path})
      pushcli_token=$(cat ${config.sops.secrets."pushcli/token".path})
      ${pushcli}/bin/pushcli -u "$pushcli_user" -t "$pushcli_token" "mainframe: startup finished"
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };
}
