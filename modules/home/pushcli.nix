{ inputs, config, pkgs, ... }:

{
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
