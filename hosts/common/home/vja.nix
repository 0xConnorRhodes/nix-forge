{ config, secrets, lib, pkgs, ... }:

{
  # write Vikunja CLI configuration to XDG_CONFIG_HOME
  home.file.".config/vja/config.rc".text = ''
    [application]
    frontend_url=https://tasks.connorrhodes.com/
    api_url=https://tasks.connorrhodes.com/api/v1
  '';
}
