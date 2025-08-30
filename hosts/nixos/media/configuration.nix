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
      kernelParams = [
        "snd_bcm2835.enable_hdmi=1"
        "snd_bcm2835.enable_headphones=1"
        "console=serial0,115200"
        "console=tty1"
      ];
    };

    hardware.raspberry-pi."4".fkms-3d.enable = true;
    hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;

    # Automated HDMI audio configuration
    # This systemd service will automatically add the required HDMI audio settings to config.txt
    systemd.services.raspberry-pi-hdmi-audio = {
      description = "Configure Raspberry Pi HDMI Audio";
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        CONFIG_FILE="/boot/firmware/config.txt"
        BACKUP_FILE="/boot/firmware/config.txt.backup"

        # Check if config.txt exists (it might be in /boot/config.txt instead)
        if [ ! -f "$CONFIG_FILE" ]; then
          CONFIG_FILE="/boot/config.txt"
          BACKUP_FILE="/boot/config.txt.backup"
        fi

        if [ -f "$CONFIG_FILE" ]; then
          # Create backup if it doesn't exist
          if [ ! -f "$BACKUP_FILE" ]; then
            cp "$CONFIG_FILE" "$BACKUP_FILE"
          fi

          # Check if our HDMI audio settings are already present
          if ! grep -q "# NixOS HDMI Audio Configuration" "$CONFIG_FILE"; then
            echo "Adding HDMI audio configuration to $CONFIG_FILE"
            cat >> "$CONFIG_FILE" << 'EOF'

# NixOS HDMI Audio Configuration
hdmi_group=1
hdmi_mode=16
hdmi_drive=2
EOF
          else
            echo "HDMI audio configuration already present in $CONFIG_FILE"
          fi
        else
          echo "Warning: config.txt not found at expected locations"
        fi
      '';
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
      kdePackages.bluedevil
      firefox
      xterm
      pcmanfm
      htop
      xorg.xclock
      networkmanagerapplet  # Network manager GUI
    ];

    programs.zsh.enable = true;

    users.users.${config.myConfig.username} = {
      isNormalUser = true;
      description = "Connor Rhodes";
      extraGroups = [ "networkmanager" "wheel" "audio"];
      shell = pkgs.zsh;
      # Add your SSH keys here for initial access
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHczZo2Xoo9jN7BGmtu2nabaSzFq9sW2Y4eh7UELReA connor@devct"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvE1Dk8jXCzFOqyph0k8Lp/ynYMX5vqA/MZni2L/JE4 connor@rhodes.contact"
      ];
    };

    users.users.media = {
      isNormalUser = true;
      description = "Media User";
      extraGroups = [ "networkmanager" "audio"];
      shell = pkgs.zsh;
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

    # Home manager configuration for media user
    home-manager.users.media = { pkgs, ... }: {
      home.stateVersion = "25.05";

      imports = [
        ./media-home.nix
      ];

      # Copy JWM configuration file to user's home directory
      home.file.".jwmrc".text = builtins.readFile ./jwmrc;
    };

    system.stateVersion = "25.05";
  };
}
