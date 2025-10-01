{ inputs, config, pkgs, ... }:

{
  programs.uv = {
    enable = true;
    settings = {
      python-downloads = "never";          # don't auto-download from python.org
      python-preference = "only-system";   # only use system Python
    };
  };
}
