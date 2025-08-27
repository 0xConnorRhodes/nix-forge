{ config, lib, pkgs, inputs, secrets, ... }:

{
  imports = [
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
      tailscaleIp = "100.80.72.15";
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
    };

    system.stateVersion = "25.05";
  };
}
