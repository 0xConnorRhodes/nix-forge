{ pkgs, ... }: 
{
  system.defaults.finder = {
    AppleShowAllExtensions = true; # show file extensions in finder
    _FXShowPosixPathInTitle = true;
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  system.defaults.NSGlobalDomain = {
    InitialKeyRepeat = 10;
    KeyRepeat = 3;
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # allow nix-darwin to manage and update nix-daemon
  services.nix-daemon.enable = true;

  # from initial install, needed for backward compatibility
  system.stateVersion = 5;
}