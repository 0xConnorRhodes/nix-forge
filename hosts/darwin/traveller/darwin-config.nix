{ config, lib, pkgs, inputs, ... }: 

{
  # imports = [
  #         inputs.home-manager.darwinModules.home-manager
  # ];

  options = {
    myConfig = {
      username = lib.mkOption { type = lib.types.str; default = "connor.rhodes";};
      homeDir = lib.mkOption { type = lib.types.str; default = "/Users/connor.rhodes";};
      # hostname = lib.mkOption { type = lib.types.str; default = "mpro";};
    };
  };

  config = {
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

    # home-manager.users.default = { pkgs, ... }: {
    # home-manager.users.${config.myConfig.username} = { pkgs, ... }: {
    #   home.stateVersion = "24.11";
    #   imports = [
    #     # ./home.nix
    #   ]; 
    # };
            users.users.${config.myConfig.username}.home = config.myConfig.homeDir;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              # # extraSpecialArgs = { inherit pwnvim; };
              # users.default.imports = [ ./modules/home-manager ];
              users."connor.rhodes".imports = [  ];
              users."connor.rhodes".home.stateVersion = "24.11";
              # users."connor.rhodes".home.homeDirectory = /Users/connor.rhodes;
            };

    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # allow nix-darwin to manage and update nix-daemon
    services.nix-daemon.enable = true;

    # from initial install, needed for backward compatibility
    system.stateVersion = 5;
  };
}