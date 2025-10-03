{ inputs, config, pkgs, ... }:

{
  programs.uv = {
    enable = true;
    settings = {
      python-downloads = "automatic";
      python-preference = "managed";
    };
  };

  # set global default python version
  # equivalent to uv python pin --global <version>
  home.file.".config/uv/.python-version".text = "3.12";
}
