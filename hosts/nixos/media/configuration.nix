{ config, lib, pkgs, inputs, secrets, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./secret.nix
    ../../common/host-options.nix
    ../../common/nixos-common.nix
    # ../../common/nixos-packages.nix
    ../../../configs/ssh_config.nix
    ../../../modules/nixos/tailscale.nix
    inputs.nixos-hardware.nixosModules.raspberry-pi-4 # or change to raspberry-pi-5 if you have a Pi 5
    inputs.nix-index-database.nixosModules.nix-index
  ];

  config = {
    myConfig = {
      username = "connor";
      homeDir = "/home/connor";
      trashcli = "trash";
      modAlt = "ctrl";
      modCtrl = "alt";
      hostPaths = [];
    };

    # Raspberry Pi specific settings
    boot = {
      loader = {
        grub.enable = false;
        generic-extlinux-compatible.enable = true;
      };
      consoleLogLevel = lib.mkDefault 7;

      # Basic Pi kernel parameters
      kernelParams = [ "console=serial0,115200" "console=tty1" ];
    };

    networking = {
      hostName = "media";
      networkmanager = {
        enable = true;
        ensureProfiles = {
          profiles = {
            home-wifi = {
              connection = {
                id = "home-wifi";
                type = "wifi";
                autoconnect = true;
              };
              wifi = {
                ssid = secrets.wifi.home.ssid;
                mode = "infrastructure";
              };
              wifi-security = {
                key-mgmt = "wpa-psk";
                psk = secrets.wifi.home.password;
              };
              ipv4 = {
                method = "auto";
              };
            };
          };
        };
      };
    };

    time.timeZone = "America/Chicago";

    # Enable the X11 windowing system and JWM
    services.xserver.enable = true;
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
=======
=======
>>>>>>> Stashed changes
    services.xserver.windowManager.jwm.enable = true;

    # Disable screen saver and DPMS
    services.xserver.xkb.options = "terminate:ctrl_alt_bksp";
    services.xserver.displayManager.sessionCommands = ''
      ${pkgs.xorg.xset}/bin/xset -dpms
      ${pkgs.xorg.xset}/bin/xset s noblank
      ${pkgs.xorg.xset}/bin/xset s off
    '';

    services.displayManager = {
      autoLogin = {
        enable = true;
        user = "media";
      };
      defaultSession = "none+jwm";
    };

    # Power management - prevent screen blanking and system suspension
    services.xserver.serverFlagsSection = ''
      Option "BlankTime" "0"
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime" "0"
    '';

    # Disable power management and suspend
    powerManagement = {
      enable = false;
      powertop.enable = false;
    };

    # Disable systemd sleep and suspend targets
    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    programs.kdeconnect.enable = false;
    hardware.bluetooth.enable = true;

    environment.systemPackages = with pkgs; [
<<<<<<< Updated upstream
<<<<<<< Updated upstream
      kdePackages.bluedevil
=======
=======
>>>>>>> Stashed changes
      firefox
      xterm
      pcmanfm  # File manager
      htop    # System monitor
      xorg.xclock
      networkmanagerapplet  # Network manager GUI
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
    ];

    programs.zsh.enable = true;

    users.users.${config.myConfig.username} = {
      isNormalUser = true;
      description = "Connor Rhodes";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      # Add your SSH keys here for initial access
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHczZo2Xoo9jN7BGmtu2nabaSzFq9sW2Y4eh7UELReA connor@devct"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvE1Dk8jXCzFOqyph0k8Lp/ynYMX5vqA/MZni2L/JE4 connor@rhodes.contact"
      ];
    };

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    # Home manager configuration
    home-manager.backupFileExtension = "bak";
    home-manager.users.${config.myConfig.username} = { pkgs, ... }: {
      home.stateVersion = "25.05";
      imports = [
        ./home.nix
      ];

      # Copy JWM configuration file to user's home directory
      home.file.".jwmrc".text = builtins.readFile ./jwmrc;

      # Set up X session to start JWM
      xsession = {
        enable = true;
        windowManager.command = "${pkgs.jwm}/bin/jwm";
      };
    };

<<<<<<< Updated upstream
=======
    # Home manager configuration for media user
    home-manager.users.media = { pkgs, ... }: {
      home.stateVersion = "25.05";
      imports = [
        ./firefox.nix
      ];

      # Copy JWM configuration file to media user's home directory
      home.file.".jwmrc".text = builtins.readFile ./jwmrc;

      # Set up X session to start JWM
      xsession = {
        enable = true;
        windowManager.command = "${pkgs.jwm}/bin/jwm";
      };
    };

>>>>>>> Stashed changes
    system.stateVersion = "25.05";
  };
}
