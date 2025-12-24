{ inputs, config, pkgs, secrets, ... }:

{
  home.file.".config/pushcli/pushcli.conf".text = ''
    user=${secrets.pushcli.user}
    token=${secrets.pushcli.token}
    priority=normal
    verbose=0
    quiet=0
  '';
}
