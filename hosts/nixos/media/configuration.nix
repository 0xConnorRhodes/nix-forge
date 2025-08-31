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

    # Distributed builds configuration
    nix = {
      distributedBuilds = true;

      buildMachines = [
        {
          # TODO: change back to shortname when testing finished
          hostName = "acorn.taila2416.ts.net"; # Use full Tailscale hostname
          sshUser = "nix-ssh";           # user provided by nix.sshServe
          system = "aarch64-linux";
          protocol = "ssh-ng";
          maxJobs = 6;
          speedFactor = 2;
          supportedFeatures = [ "big-parallel" "kvm" ];
          sshKey = "/etc/ssh/nix-builders/id_ed25519";  # Use properly permissioned key
          publicHostKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFhGQBo2OYv8NbdeXLp4FaoQzgLSv79q29/9C4H8DGw2";
        }
      ];

      settings = {
        builders-use-substitutes = true;
        # Keep official cache for prebuilt stuff
        substituters = [
          "https://cache.nixos.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];
      };
    };

    # Make sure we use 64-bit on the Pi
    nixpkgs.hostPlatform = "aarch64-linux";

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

      # Basic configuration for Raspberry Pi
      extraConfig.pipewire."99-rpi-audio" = {
        context.properties = {
          default.clock.rate = 48000;
        };
      };

      # WirePlumber configuration for Raspberry Pi
      wireplumber = {
        enable = true;
        extraConfig."51-rpi-hdmi" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  "device.name" = "alsa_card.platform-bcm2835_audio";
                }
              ];
              actions = {
                update-props = {
                  "api.acp.auto-profile" = false;
                  "api.acp.auto-port" = false;
                };
              };
              apply_properties = {
                "device.profile" = "pro-audio";
              };
            }
            {
              matches = [
                {
                  "device.name" = "alsa_card.platform-bcm2835_audio.2";
                }
              ];
              actions = {
                update-props = {
                  "api.acp.auto-profile" = false;
                  "api.acp.auto-port" = false;
                };
              };
              apply_properties = {
                "device.profile" = "pro-audio";
              };
            }
          ];
        };
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
    '';

    # Service to ensure HDMI audio is detected
    systemd.services.hdmi-audio-setup = {
      description = "Setup HDMI Audio";
      wantedBy = [ "multi-user.target" ];
      after = [ "sound.target" "pipewire.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        # Force load audio modules
        ${pkgs.kmod}/bin/modprobe snd-bcm2835

        # Wait for audio devices to appear
        sleep 3

        # Check if audio devices are available
        if [ -e /proc/asound/cards ]; then
          echo "Audio cards detected:"
          cat /proc/asound/cards
        fi

        # Try to activate HDMI profile via systemd user service
        if [ -e /dev/snd/controlC0 ]; then
          echo "HDMI control device found"
          # Set card profile to activate HDMI output
          systemctl --user restart pipewire pipewire-pulse || true
          sleep 2
        fi
      '';
    };

    # Service to setup SSH key for remote builds (needed to fix permissions on nix written root key)
    systemd.services.setup-nix-builder-ssh = {
      description = "Setup SSH key for Nix remote builds";
      wantedBy = [ "multi-user.target" ];
      before = [ "nix-daemon.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        # Create directory for builder SSH keys
        mkdir -p /etc/ssh/nix-builders

        # Copy SSH key with proper permissions
        if [ -f /root/.ssh/id_ed25519 ]; then
          cp /root/.ssh/id_ed25519 /etc/ssh/nix-builders/id_ed25519
          chmod 600 /etc/ssh/nix-builders/id_ed25519
          chown root:root /etc/ssh/nix-builders/id_ed25519
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

      # fix fullscreen video playback on Raspberry Pi
      home.file.".config/mpv/mpv.conf".text = ''
        fs=yes
        vo=gpu
        gpu-context=x11egl
        hwdec=auto-copy
      '';

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

      # fix fullscreen video playback on Raspberry Pi
      home.file.".config/mpv/mpv.conf".text = ''
        fs=yes
        vo=gpu
        gpu-context=x11egl
        hwdec=auto-copy
      '';
    };

    system.stateVersion = "25.05";
  };
}
