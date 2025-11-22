{ config, lib, pkgs, inputs, secrets, ... }:

{
  imports = [
    ./darwin-secret.nix
    ./launchd.nix
    ../../common/host-options.nix
    ../../../configs/ssh_config.nix
  ];

  config = {
    myConfig = {
      username = "connor.rhodes";
      homeDir = "/Users/connor.rhodes";
      modAlt = "cmd";
      modCtrl = "ctrl";
      hostPaths = [
        "$CODE/scripts/darwin"
      ];
    };

    nixpkgs.config.allowUnsupportedSystem = true;

    system.primaryUser = config.myConfig.username;
    system.defaults.finder = {
      AppleShowAllExtensions = true; # show file extensions in finder
      _FXShowPosixPathInTitle = false; # show full path in finder title
    };

    environment.pathsToLink = [ "/share/zsh" ];

    system.defaults.dock = {
      autohide = true;
      appswitcher-all-displays = true; # show alt-tab on all monitors
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

    # shells that will be accessible from chsh
    environment.shells = [ pkgs.zsh ];
    users.users.${config.myConfig.username} = {
      home = config.myConfig.homeDir;
      shell = pkgs.zsh;
    };

    home-manager = {
      backupFileExtension = "bak"; # append existing non hm files with this on rebuild
      # useUserPackages = true; # if true install home-manager packages in /etc/profiles. Needed for nixos-rebuild build-vm.
      extraSpecialArgs = {
        inherit inputs;
        inherit secrets;
        # Pass host-specific paths from myConfig
        hostPaths = config.myConfig.hostPaths;
      };
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
