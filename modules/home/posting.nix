{ inputs, config, pkgs, ... }:

{
  home.file.".config/posting/config.yaml".text = ''
    spacing: compact
  '';
}