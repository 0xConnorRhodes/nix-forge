{ config, lib, pkgs, inputs, secrets, ... }: 

{
  options = {
    myConfig = {
      username = lib.mkOption { type = lib.types.str; default = "connor.rhodes";};
      homeDir = lib.mkOption { type = lib.types.str; default = "/Users/connor.rhodes";};
    };
  };

  config = {
    system.defaults.finder = {
      AppleShowAllExtensions = true; # show file extensions in finder
      _FXShowPosixPathInTitle = false; # show full path in finder title
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

    # nix-homebrew options install homebrew, homebrew options below install packages with homebrew
    nix-homebrew = {
      enable = true;
      # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
      enableRosetta = false;

      # User owning the Homebrew prefix
      user = config.myConfig.username;

      # Optional: Enable fully-declarative tap management
      #
      # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
      mutableTaps = false;
      
      # declarative tap management from nix flake
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
      };
    };

    homebrew = {
      caskArgs.no_quarantine = true;
      global.brewfile = true;

      casks = [ 
        "ghostty" 
        "visual-studio-code" # run install code command in PATH from VSCode command palate after install
      ];
    };

    users.users.${config.myConfig.username} = {
      home = config.myConfig.homeDir;
      shell = pkgs.zsh;
    }; 

    home-manager = {
      # Some tutorials say these are required...
      # useGlobalPkgs = true;
      # useUserPackages = true;
      extraSpecialArgs = { inherit inputs; inherit secrets; };
      users.${config.myConfig.username} = {
        home.stateVersion = "24.11";
        imports = [ ./home.nix ];
      };
    };

    # will use default config file at ~/skhd/skhdrc
    services.skhd.enable = true;

    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    security.pam.enableSudoTouchIdAuth = true;

    # allow nix-darwin to manage and update nix-daemon
    services.nix-daemon.enable = true;

    # from initial install, needed for backward compatibility
    system.stateVersion = 5;
  };
}