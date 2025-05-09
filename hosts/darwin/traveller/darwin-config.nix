{ config, lib, pkgs, inputs, secrets, ... }: 

{
  imports = [ 
    ./darwin-secret.nix 
    ./launchd.nix
  ];

  options = {
    myConfig = {
      username = lib.mkOption { type = lib.types.str; default = "connor.rhodes";};
      homeDir = lib.mkOption { type = lib.types.str; default = "/Users/connor.rhodes";};
      trashcli = lib.mkOption { type = lib.types.str; default = "trash";}; # built in to macOS
    };
  };

  config = {
    system.defaults.finder = {
      AppleShowAllExtensions = true; # show file extensions in finder
      _FXShowPosixPathInTitle = false; # show full path in finder title
    };

    environment.pathsToLink = [ "/share/zsh" ];

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
      ApplePressAndHoldEnabled = false;
    };

    fonts.packages = [ (pkgs.nerdfonts.override { fonts = [
        # pass keys from https://github.com/NixOS/nixpkgs/blob/nixos-24.11/pkgs/data/fonts/nerdfonts/shas.nix
        # as strings to selectively install nerd fonts
        "GeistMono"
        "JetBrainsMono"
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
      enable = true;
      caskArgs.no_quarantine = true;
      global.brewfile = true;
      onActivation.cleanup = "uninstall"; # uninstall brew packages not listed in nix

      casks = [ 
        "ghostty" 
        "balenaetcher"
        # "hammerspoon"
        # "pine" # mac native markdown editor
        # "macs-fan-control"
        "jupyterlab"
        # "kdenlive"
        "vlc"
        "wireshark"
      ];

      masApps = { 
        "iMovie" = 408981434;
        "Yoink" = 457622435;
      };

    };

    # shells that will be accessible from chsh
    environment.shells = [ pkgs.zsh ];
    users.users.${config.myConfig.username} = {
      home = config.myConfig.homeDir;
      shell = pkgs.zsh;
    }; 

    home-manager = {
      useGlobalPkgs = true; # use system level nixpkgs (shortens eval time) instead of an independent copy
      backupFileExtension = "bak"; # append existing non hm files with this on rebuild
      # useUserPackages = true; # if true install home-manager packages in /etc/profiles. Needed for nixos-rebuild build-vm.
      extraSpecialArgs = { inherit inputs; inherit secrets; };
      users.${config.myConfig.username} = {
        home.stateVersion = "24.11";
        imports = [ ./home.nix ];
      };
    };

    # will use default config file at ~/skhd/skhdrc
    # services.skhd.enable = true;

    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    security.pam.enableSudoTouchIdAuth = true;

    # allow nix-darwin to manage and update nix-daemon
    services.nix-daemon.enable = true;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 5;
  };
}
