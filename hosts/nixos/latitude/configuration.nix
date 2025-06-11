{ config, lib, pkgs, inputs, pkgsUnstable, secrets, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./packages.nix
      ./gnome.nix
      ./ssh-mosh.nix
      ./secret.nix
      #./kiosk.nix
      ../../common/nixos-common.nix
      ../../common/nixos-packages.nix
      ../../common/gnome-common.nix
      ../../../modules/nixos/kvm.nix
      #../../../modules/nixos/incus.nix
      ../../../modules/nixos/tailscale.nix
      ../../../modules/nixos/sync-notes.nix
      ../../../modules/nixos/ulauncher.nix
      inputs.home-manager.nixosModules.default
      inputs.nix-index-database.nixosModules.nix-index
    ];

  options = {
    myConfig = {
      username = lib.mkOption { type = lib.types.str; default = "connor";};
      trashcli = lib.mkOption { type = lib.types.str; default = "trash";}; # from pkgs.trashy
      homeDir = lib.mkOption { type = lib.types.str; default = "/home/connor";};
      modAlt = lib.mkOption { type = lib.types.str; default = "alt"; }; # modkey on the physical Alt key on a conventional keyboard
    };
  };

  config = {
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 5; # max number of previous system builds in bootloader
    };
    boot.loader.efi.canTouchEfiVariables = true;
    
    # zfs
    boot.kernelPackages = pkgs.pkgs.linuxPackages_xanmod; # xanmod LTS kernel
    boot.supportedFilesystems = [ "zfs" ];
    networking.hostId = "4539c42d"; # needed by zfs to track unique machines for pool import

    networking.hostName = "latitude";
    networking.networkmanager.enable = true;

    time.timeZone = "America/Chicago";

    programs.zsh = {
      enable = true;
    };

    users.users.${config.myConfig.username} = {
      isNormalUser = true;
      description = "Connor Rhodes";
      extraGroups = [ "networkmanager" "wheel" ];
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
    home-manager.users.${config.myConfig.username} = { pkgs, ... }: {
      home.stateVersion = "24.11";
      imports = [
       ./home.nix
       ../../common/gnome-dconf-common.nix
      ]; 
    };

    # services
    services.printing.enable = true;
    services.psd.enable = true;

    # prevent password prompt on opening vscode
    security.pam.services.gdm-password.enableGnomeKeyring = true;

    # subsystems
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    system.stateVersion = "24.11";
  };
}
