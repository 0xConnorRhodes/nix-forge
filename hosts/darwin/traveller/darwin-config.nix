{ config, lib, pkgs, inputs, secrets, ... }:

{
  imports = [
    ./darwin-secret.nix
    ./launchd.nix
    ../../../configs/ssh_config.nix
  ];

  options = {
    myConfig = {
      username = lib.mkOption { type = lib.types.str; default = "connor.rhodes";};
      homeDir = lib.mkOption { type = lib.types.str; default = "/Users/connor.rhodes";};
      trashcli = lib.mkOption { type = lib.types.str; default = "trash";}; # built in to macOS
      modAlt = lib.mkOption { type = lib.types.str; default = "cmd"; }; # modkey on the physical Alt key on a conventional keyboard
      modCtrl = lib.mkOption { type = lib.types.str; default = "ctrl"; }; # modkey on the physical Alt key on a conventional keyboard
    };
  };

  config = {
    system.primaryUser = config.myConfig.username;
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

    fonts.packages = with pkgs; [
      nerd-fonts.geist-mono
      nerd-fonts.jetbrains-mono
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
        "jupyterlab"
        # "kdenlive"
        "vlc"
        "wireshark"
        "vieb"
        "qutebrowser"
        "pine" # markdown editor
        "zen"
        # "vivaldi" # installed directly
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

    nix = {
      enable = true;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };

    security.pam.services.sudo_local.touchIdAuth = true;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 5;
  };
}
