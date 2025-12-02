{ inputs, config, pkgs, ... }:

{
  home.file.".config/posting/config.yaml".text = ''
    spacing: compact
    use_host_environment: true # use system env vars (fnox)
  '';
}
