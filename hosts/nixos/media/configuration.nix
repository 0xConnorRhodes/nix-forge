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
        # Add device tree parameter for audio
        generic-extlinux-compatible.configurationLimit = 1;
      };
      consoleLogLevel = lib.mkDefault 7;

      # Basic Pi kernel parameters including audio
      kernelParams = [
        "snd_bcm2835.enable_hdmi=1"
        "snd_bcm2835.enable_headphones=1"
        "console=serial0,115200"
        "console=tty1"
        "dtparam=audio=on"
      ];

      # Ensure audio modules are loaded
      kernelModules = [ "snd-bcm2835" ];
    };

    hardware.raspberry-pi."4".fkms-3d.enable = true;
    hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;

    # Automated HDMI audio configuration

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

    # Enable sound with pipewire and force HDMI audio detection
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # Force HDMI audio to be available
      extraConfig.pipewire."92-low-latency" = {
        context.properties = {
          default.clock.rate = 48000;
          default.clock.quantum = 32;
          default.clock.min-quantum = 32;
          default.clock.max-quantum = 32;
        };
      };
      # Configure ALSA for HDMI audio
      extraConfig.pipewire-pulse."92-low-latency" = {
        context.modules = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              pulse.min.req = "32/48000";
              pulse.default.req = "32/48000";
              pulse.max.req = "32/48000";
              pulse.min.quantum = "32/48000";
              pulse.max.quantum = "32/48000";
            };
          }
        ];
        stream.properties = {
          node.latency = "32/48000";
          resample.quality = 1;
        };
      };
      # Raspberry Pi specific ALSA configuration
      extraConfig.pipewire."99-rpi-hdmi" = {
        context.modules = [
          {
            name = "libpipewire-module-adapter";
            args = {
              factory.name = "support.null-audio-sink";
              node.name = "rpi-hdmi";
              node.description = "Raspberry Pi HDMI";
              media.class = "Audio/Sink";
              audio.position = [ "FL" "FR" ];
              monitor.channel-volumes = true;
            };
          }
        ];
      };
    };

    programs.kdeconnect.enable = false;
    hardware.bluetooth.enable = true;

    # Force ALSA to load HDMI audio card
    boot.extraModprobeConfig = ''
      options snd-bcm2835 enable_hdmi=1 enable_headphones=1
    '';

    # Create ALSA configuration for HDMI audio
    environment.etc."asound.conf".text = ''
      pcm.!default {
        type pulse
      }
      ctl.!default {
        type pulse
      }

      # Make HDMI the default audio output
      pcm.hdmi {
        type hw
        card 0
        device 1
      }
    '';

    # Service to ensure HDMI audio is detected
    systemd.services.hdmi-audio-setup = {
      description = "Setup HDMI Audio";
      wantedBy = [ "multi-user.target" ];
      after = [ "sound.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        # Force load audio modules
        ${pkgs.kmod}/bin/modprobe snd-bcm2835

        # Wait for audio devices to appear
        sleep 2

        # Force HDMI audio detection
        if [ -e /proc/asound/cards ]; then
          echo "Audio cards detected:"
          cat /proc/asound/cards
        fi

        # Set HDMI as default if available
        if ${pkgs.alsa-utils}/bin/aplay -l | grep -q "HDMI"; then
          echo "HDMI audio detected"
        fi
      '';
    };

    environment.systemPackages = with pkgs; [
      kdePackages.bluedevil
      firefox
      xterm
      pcmanfm
      htop
      xorg.xclock
      networkmanagerapplet  # Network manager GUI
      pavucontrol           # Audio control
      alsa-utils           # ALSA utilities for audio debugging
      pulseaudio           # For pactl commands
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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID+LN8Mv7LSJ+fJzXQE1vBQW5LTlbXGFP7f/NrF8ZEm9 connor@acorn"
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
