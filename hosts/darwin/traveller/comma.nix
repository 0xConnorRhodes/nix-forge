{ config, pkgs, inputs, secrets, ... }:

{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];

  programs.nix-index-database.comma.enable = true;

  # NOTE: if comma produces warning:
  # '/nix/var/nix/profiles/per-user/root/channels'
  # can run `sudo mkdir /nix/var/nix/profiles/per-user/root/channels` to clear
}