{ inputs, config, pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    package = pkgs.direnv.overrideAttrs (_: { doCheck = false; });
    silent = true; # disable debug output in terminal when direnv activates
  };
}
