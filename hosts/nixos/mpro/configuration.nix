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
      ./syncthing.nix
      ./nfs.nix
      # ./llm.nix
      ../../common/nixos-common.nix
      ../../common/nixos-packages.nix
      ../../../modules/nixos/profile-sync-daemon.nix
      ../../../modules/nixos/caddy.nix
      ../../../modules/nixos/dashy
      ../../../modules/nixos/authelia.nix
      ../../../modules/services/pairdrop.nix
      ../../../modules/services/copyparty.nix
      ../../../modules/services/shiori.nix
      #../../../modules/services/miniflux.nix
      ../../../modules/nixos/kvm.nix
      #../../../modules/nixos/incus.nix
      ../../../modules/nixos/tailscale.nix

      # services
      ../../../configs/ssh_config.nix
      ../../../modules/nixos/jellyfin.nix
      ../../../modules/services/navidrome.nix
      ../../../modules/services/audiobookshelf.nix
      ../../../modules/services/web-print.nix

      # jobs
      ../../../modules/jobs/sync-notes.nix
      ../../../modules/jobs/monitor_podcasts.nix
      ../../../modules/jobs/zk-cron.nix
      ../../../modules/jobs/db-backup.nix
      ../../../modules/jobs/readeck-backup.nix
      inputs.home-manager.nixosModules.default
      inputs.nix-index-database.nixosModules.nix-index
    ];

  options = {
    myConfig = {
      username = lib.mkOption { type = lib.types.str; default = "connor";};
      hostname = lib.mkOption { type = lib.types.str; default = "mpro";};
      homeDir = lib.mkOption { type = lib.types.str; default = "/home/connor";};
      tailscaleIp = lib.mkOption { type = lib.types.str; default = "127.0.0.1";};
      hostPaths = lib.mkOption { type = lib.types.listOf lib.types.str; default = []; };
      trashcli = lib.mkOption { type = lib.types.str; default = "trash"; }; # from pkgs.trashy
      modAlt = lib.mkOption { type = lib.types.str; default = "ctrl"; }; # modkey on the physical Alt key on a conventional keyboard
      modCtrl = lib.mkOption { type = lib.types.str; default = "alt"; }; # modkey on the physical Ctrl key on a conventional keyboard
    };
  };

  config = {
    myConfig.hostPaths = [
      "/usr/local/bin"
      "$HOME/.local/share/flatpak/exports/bin"
      "/var/lib/flatpak/exports/bin"
    ];

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

    # Networking
    myConfig.tailscaleIp = "100.80.72.12";
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

    users.users.${config.myConfig.username} = {
      isNormalUser = true;
      description = "Connor Rhodes";
      extraGroups = [ "networkmanager" "wheel" "docker"];
      shell = pkgs.zsh;
      openssh = {
        authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHczZo2Xoo9jN7BGmtu2nabaSzFq9sW2Y4eh7UELReA connor@devct"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvE1Dk8jXCzFOqyph0k8Lp/ynYMX5vqA/MZni2L/JE4 connor@rhodes.contact"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHDPTeOGdCMgihUyRXEmpFdJeFSKoB6VGSou13+f8dI6 u0_a301@localhost" # termux
        ];
      };
    };

    home-manager.backupFileExtension = "bak"; # append existing non hm files with this on rebuild
    home-manager.extraSpecialArgs = {
      hostPaths = config.myConfig.hostPaths;
    };
    nixpkgs.config.allowUnfree = true;
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

    services.logind.extraConfig = ''
      HandleLidSwitchExternalPower=ignore
    '';

    # services
    programs.mosh.enable = true;

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

    # subsystems
    virtualisation.docker.enable = true;

    system.stateVersion = "24.11";
  };
}
