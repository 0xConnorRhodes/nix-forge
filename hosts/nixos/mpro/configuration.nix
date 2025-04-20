{ config, lib, pkgs, inputs, pkgsUnstable, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      # ./gnome.nix
      ./secret.nix
      # #./kiosk.nix
      ../../common/packages.nix
      ../../common/nixos-common.nix
      ../../common/nixos-packages.nix
      ../../common/gnome-common.nix
      ../../../modules/nixos/incus.nix
      ../../../modules/nixos/sync-notes.nix
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
      extraGroups = [ "networkmanager" "wheel" ];
    };

    home-manager.users.${config.myConfig.username} = { pkgs, ... }: {
      home.stateVersion = "24.11";
      imports = [
        ./home.nix
        ../../common/gnome-dconf-common.nix
      ]; 
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

    system.stateVersion = "24.11";
  };
}
