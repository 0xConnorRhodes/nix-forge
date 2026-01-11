{ config, lib, pkgs, inputs, secrets, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./packages.nix
      #./gnome.nix
      ./plasma.nix
      ./mounts.nix
      ./secret.nix
      ./backup-cron.nix
      #./syncthing.nix
      ./nfs.nix
      # ./llm.nix
      ../../common/host-options.nix
      ../../common/nixos-common.nix
      ../../common/nixos-packages.nix
      ../../../modules/nixos/profile-sync-daemon.nix
      ../../../modules/nixos/caddy.nix
      ../../../modules/nixos/dashy
      ../../../modules/nixos/authelia.nix
      ../../../modules/nixos/kvm.nix
      ../../../modules/nixos/incus.nix
      ../../../modules/nixos/tailscale.nix

      # services
      ../../../configs/ssh_config.nix
      ../../../modules/nixos/jellyfin.nix
      ../../../modules/services/navidrome.nix
      ../../../modules/services/audiobookshelf.nix
      ../../../modules/services/web-print.nix
      ../../../modules/services/vaultwarden.nix
      ../../../modules/services/immich.nix
      ../../../modules/services/pairdrop.nix
      ../../../modules/services/copyparty.nix
      ../../../modules/services/silverbullet.nix
      ../../../modules/services/vikunja.nix
      ../../../modules/services/nextcloud.nix
      ../../../modules/services/fastapi.nix
      #../../../modules/services/open-webui.nix

      # jobs
      ../../../modules/jobs/sync-notes.nix
      ../../../modules/jobs/monitor_podcasts.nix
      # ../../../modules/jobs/zk-cron.nix
      ../../../modules/jobs/transcode-musiclibrary.nix
      ../../../modules/jobs/db-backup.nix
      ../../../modules/jobs/readeck-backup.nix
      ../../../modules/jobs/backup-secrets.nix
      # ../../../modules/jobs/rclone-jobs.nix
      inputs.home-manager.nixosModules.default
      inputs.nix-index-database.nixosModules.nix-index
    ];

  options = {
    myConfig = {
      hostname = lib.mkOption { type = lib.types.str; default = "mpro";};
      tailscaleIp = lib.mkOption { type = lib.types.str; default = "127.0.0.1";};
    };
  };

  config = {
    myConfig = {
      username = "connor";
      homeDir = "/home/connor";
      trashcli = "trash"; # from pkgs.trashy
      modAlt = "ctrl"; # modkey on the physical Alt key on a conventional keyboard
      modCtrl = "alt"; # modkey on the physical Ctrl key on a conventional keyboard
      hostPaths = [
        "/usr/local/bin"
        "$HOME/.local/share/flatpak/exports/bin"
        "/var/lib/flatpak/exports/bin"
      ];
      tailscale.isExitNode = true;
      tailscaleIp = "100.80.72.12";
    };

    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 5; # max number of previous system builds in bootloader
    };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.timeout = 0; # hold space during boot to see boot selection menu

    # zfs
    boot.kernelPackages = pkgs.pkgs.linuxPackages_xanmod; # xanmod LTS kernel
    boot.supportedFilesystems = [ "zfs" ];
    networking.hostId = "eca3fb4d";
    boot.zfs.forceImportRoot = false;

    # Networking
    networking = {
      hostName = config.myConfig.hostname;
      useDHCP = false;
      networkmanager.enable = true;

      interfaces.enp9s0.ipv4.addresses = [{
        address = "192.168.86.11";
        prefixLength = 24;
      }];

      defaultGateway = "192.168.86.1";
      nameservers = [ "1.1.1.1" "1.0.0.1" ];
    };
    networking.firewall.enable = true;
    networking.firewall.trustedInterfaces = [ "lo" ];

    time.timeZone = "America/Chicago";

    # keyboard settings
    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ]; # Applies to all keyboards
          settings = {
            main = {
              capslock = "leftalt";
              leftalt = "leftcontrol";
              rightalt = "rightcontrol";
              rightcontrol = "rightmeta";
              leftcontrol = "leftalt";
            };

            alt = {
              "[" = "esc";
              d = "C-d";
              c = "C-c";
              r = "C-r";
            };
          };
        };
      };
    };

    programs.zsh = {
      enable = true;
    };

    # Android debugging
    programs.adb.enable = true;
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="adbusers", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="adbusers", TAG+="uaccess"
    '';

    users.users.${config.myConfig.username} = {
      isNormalUser = true;
      description = "Connor Rhodes";
      extraGroups = [ "networkmanager" "wheel" "docker" "audiobookshelf" "adbusers"];
      shell = pkgs.zsh;
      openssh = {
        authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHczZo2Xoo9jN7BGmtu2nabaSzFq9sW2Y4eh7UELReA connor@devct"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvE1Dk8jXCzFOqyph0k8Lp/ynYMX5vqA/MZni2L/JE4 connor@rhodes.contact"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHDPTeOGdCMgihUyRXEmpFdJeFSKoB6VGSou13+f8dI6 u0_a301@localhost" # termux
	  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID27aZ4iGyku0oYBHN8x8tNvfv+v2yOsUY1UQR6j2nnv connor@ipad"
        ];
      };
    };

    home-manager.backupFileExtension = "bak"; # append existing non hm files with this on rebuild
    home-manager.extraSpecialArgs = {
      hostPaths = config.myConfig.hostPaths;
    };
    nixpkgs.config.allowUnfree = true;


    # AppImage support
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
    # needed for tasker permissions appimage
    nixpkgs.config.packageOverrides = pkgs: {
      appimage-run = pkgs.appimage-run.override {
        extraPkgs = pkgs: [ pkgs.xorg.libxshmfence ];
      };
    };

    home-manager.users.${config.myConfig.username} = { pkgs, ... }: {
      home.stateVersion = "24.11";
      imports = [
        ./home.nix
        #./gnome-dconf.nix
        #./gnome-always-on.nix
        #../../common/gnome-dconf-common.nix
      ];
    };

    home-manager.users.root = { pkgs, ... }: {
      home.stateVersion = "24.11";
      imports = [
        ./root-home.nix
      ];
    };

    services.logind.settings.Login = {
      HandleLidSwitchExternalPower = "ignore";
    };

    # services
    programs.mosh.enable = true;
    programs.steam.enable = true;

    services.eternal-terminal.enable = true;
    networking.firewall.allowedTCPPorts = [ 2022 ]; # et port

    services.openssh = {
      enable = true;
      ports = [ 31583 ];
      settings.PasswordAuthentication = false;
    };

    #services.flatpak.enable = true;

    # printing
    services.printing.enable = true;
    # services.printing.listenAddresses = [ "localhost" ];
    # services.printing.webInterface = true;

    services.psd.enable = true;

    programs.gpu-screen-recorder = {
    	enable = true;
	    package = pkgs.gpu-screen-recorder;
    };

    # subsystems
    virtualisation.docker.enable = true;

    nix = {
      settings.auto-optimise-store = true;
      optimise.automatic = true;
      # Default schedule is 4:15 AM on Sunday (Weekday = 7)
    };

    system.stateVersion = "24.11";
  };
}
