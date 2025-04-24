{ pkgs, ... }: 

{
  system.defaults.finder = {
    AppleShowAllExtensions = true; # show file extensions in finder
    _FXShowPosixPathInTitle = true; # show full path in finder title
  };

  system.defaults.dock = {
    autohide = true;
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  system.defaults.NSGlobalDomain = {
    InitialKeyRepeat = 10;
    KeyRepeat = 3;
  };

  fonts.packages = [ (pkgs.nerdfonts.override { fonts = [
      # pass keys from https://github.com/NixOS/nixpkgs/blob/nixos-24.11/pkgs/data/fonts/nerdfonts/shas.nix
      # as strings to selectively install nerd fonts
      "GeistMono"
      ]; }) 
  ];

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # allow nix-darwin to manage and update nix-daemon
  services.nix-daemon.enable = true;

  # from initial install, needed for backward compatibility
  system.stateVersion = 5;
}