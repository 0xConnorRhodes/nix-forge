{ config, pkgs, pkgsUnstable, inputs, secrets, ... }:

let
  dashyConfig = import ./config.nix;
  yamlFormat = pkgs.formats.yaml { };
  configFile = yamlFormat.generate "conf.yml" dashyConfig;
in
{
  virtualisation.oci-containers.containers.dashy = {
    image = "lissy93/dashy:latest";
    ports = [ "127.0.0.1:4000:8080" ];
    volumes = [
      "${configFile}:/app/user-data/conf.yml:ro"
    ];
    autoStart = true;
  };
}
