{ inputs, config, pkgs, ... }:

let
  pushcli-src = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/markus-perl/pushover-cli/master/pushover-cli";
    hash = "sha256-DmNwkv58Bt3rwL5hEaWKMGP8LCoibVQKPkTyyyH07k4=";
  };
  pushcli = pkgs.writeShellScriptBin "pushcli" ''
    exec ${pkgs.python3}/bin/python3 ${pushcli-src} "$@"
  '';
in

{
  home.packages = [ pushcli ];

  home.shellAliases.woof = "pushcli -c ${config.home.homeDirectory}/.config/pushcli/pushcli.conf";
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ./../../secrets.yaml;
    defaultSopsFormat = "yaml";

    secrets."pushcli/user" = { };
    secrets."pushcli/token" = { };
  };

  sops.templates."pushcli.conf" = {
    content = ''
      user=${config.sops.placeholder."pushcli/user"}
      token=${config.sops.placeholder."pushcli/token"}
      priority=normal
      verbose=0
      quiet=0
    '';
    path = "${config.home.homeDirectory}/.config/pushcli/pushcli.conf";
  };
}
