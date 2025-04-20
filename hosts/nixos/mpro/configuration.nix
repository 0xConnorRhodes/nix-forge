{ config, lib, pkgs, inputs, pkgsUnstable, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./gnome.nix
      ./mounts.nix
      ./secret.nix
      ./backup-cron.nix
      ../../common/packages.nix
      ../../common/nixos-common.nix
      ../../common/nixos-packages.nix
      ../../common/gnome-common.nix
      ../../../modules/nixos/incus.nix
      ../../../modules/nixos/sync-notes.nix
      ../../../modules/nixos/jellyfin.nix
      ../../../modules/nixos/zk-cron.nix
      inputs.home-manager.nixosModules.default
    ];

  options = {
    myConfig = {
      username = lib.mkOption { type = lib.types.str; default = "connor";};
      hostname = lib.mkOption { type = lib.types.str; default = "mpro";};
    };
  };

  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    #boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;
    boot.kernelPackages = pkgs.pkgs.linuxPackages_xanmod; # xanmod LTS kernel

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

    time.timeZone = "America/Chicago";

    users.users.${config.myConfig.username} = {
      isNormalUser = true;
      description = "Connor Rhodes";
      extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
      openssh = {
        authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHczZo2Xoo9jN7BGmtu2nabaSzFq9sW2Y4eh7UELReA connor@devct"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvE1Dk8jXCzFOqyph0k8Lp/ynYMX5vqA/MZni2L/JE4 connor@rhodes.contact"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHDPTeOGdCMgihUyRXEmpFdJeFSKoB6VGSou13+f8dI6 u0_a301@localhost" # termux
        ];
    };
    };

    home-manager.users.${config.myConfig.username} = { pkgs, ... }: {
      home.stateVersion = "24.11";
      imports = [
        ./home.nix
        ./gnome-dconf.nix
        ./gnome-always-on.nix
        ../../common/gnome-dconf-common.nix
      ]; 
    };

    # suspend
    services.xserver.displayManager.gdm.autoSuspend = false;
    services.logind.extraConfig = ''
      HandleLidSwitchExternalPower=ignore
    '';

    # services
    programs.mosh.enable = true;
    services.openssh = {
      enable = true;
      ports = [ 31583 ];
      settings.PasswordAuthentication = false;
    };

    services.printing.enable = true;
    services.psd.enable = true;
    programs.firefox.enable = true;

    # bashrc to load fish if interactive
    programs.bash = {
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };
   
    # from: https://discourse.nixos.org/t/mixing-stable-and-unstable-packages-on-flake-based-nixos-system/50351/4
    # this allows you to access `pkgsUnstable` anywhere in your config
    _module.args.pkgsUnstable = import inputs.nixpkgs-unstable {
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (config.nixpkgs) config;
    };

    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [
      profile-sync-daemon
      ffmpeg-full
    ];

    # subsystems
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    # kvm/virt-manager
    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = [ config.myConfig.username ];
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;

    system.stateVersion = "24.11";
  };
}
