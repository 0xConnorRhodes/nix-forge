{ inputs, config, pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    silent = true; # disable debug output in terminal when direnv activates
  };
}
