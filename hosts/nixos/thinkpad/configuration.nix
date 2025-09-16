{ config, lib, pkgs, inputs, pkgsUnstable, secrets, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./plasma.nix
    ./ssh-mosh.nix
    ./secret.nix
    ../../common/host-options.nix
    ../../common/nixos-common.nix
    ../../common/nixos-packages.nix
    ../../common/plasma-common.nix
    ../../../modules/nixos/kvm.nix
    ../../../modules/nixos/profile-sync-daemon.nix
    #../../../modules/nixos/incus.nix
    ../../../modules/nixos/tailscale.nix
    ../../../modules/jobs/sync-notes.nix
    ../../../configs/ssh_config.nix
    inputs.home-manager.nixosModules.default
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

    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 5; # max number of previous system builds in bootloader
    };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.timeout = 0; # hold space during boot to see boot selection menu

    # zfs
    # changed (back) to xanmod on 250912
    boot.kernelPackages = pkgs.pkgs.linuxPackages_xanmod; # xanmod LTS kernel
    #boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.supportedFilesystems = [ "zfs" ];
    networking.hostId = "1c88d69b"; # needed by zfs to track unique machines for pool import, generate with `head -c 8 /etc/machine-id`

    networking.hostName = "thinkpad";
    networking.networkmanager.enable = true;

    time.timeZone = "America/Chicago";

    programs.zsh = {
      enable = true;
    };

    users.users.${config.myConfig.username} = {
      isNormalUser = true;
      description = "Connor Rhodes";
      extraGroups = [ "networkmanager" "wheel" "adbusers"];
      shell = pkgs.zsh;
      openssh = {
        authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHczZo2Xoo9jN7BGmtu2nabaSzFq9sW2Y4eh7UELReA connor@devct"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvE1Dk8jXCzFOqyph0k8Lp/ynYMX5vqA/MZni2L/JE4 connor@rhodes.contact"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHDPTeOGdCMgihUyRXEmpFdJeFSKoB6VGSou13+f8dI6 u0_a301@localhost" # termux
        ];
      };
    };

    nixpkgs.config.allowUnfree = true;

    home-manager.backupFileExtension = "bak"; # append existing non hm files with this on rebuild
    home-manager.users.${config.myConfig.username} = { pkgs, ... }: {
      home.stateVersion = "24.11";
      imports = [
       ./home.nix
      ];
    };

    # services
    services.printing.enable = true;
    services.psd.enable = true;
    programs.adb.enable = true; # ensure in user.users: extraGroups = [ "adbusers"];
    programs.appimage = {
      enable = true;
      binfmt = true; # use appimage-run to run appimage binaries
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [ pkgs.xorg.libxshmfence ];
      };
    };

    # prevent password prompt on opening vscode
    security.pam.services.gdm-password.enableGnomeKeyring = true;

    # subsystems
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

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
              rightcontrol = "rightalt";
              # print screen => rightsuper
              leftcontrol = "leftalt";
            };

            alt = {
              "[" = "esc";
              d = "C-d";
              c = "C-c";
            };
          };
        };
      };
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.05"; # Did you read the comment?
  };
}
