{ config, lib, pkgs, inputs, secrets, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./secret.nix
    ../common/host-options.nix
    ../common/nixos-common.nix
    # ../../common/nixos-packages.nix
    ../../configs/ssh_config.nix
    ../../modules/nixos/tailscale.nix
    inputs.nix-index-database.nixosModules.nix-index
  ];

  config = {
    myConfig = {
      username = ${secrets.ssh.config.acorn.user};
      homeDir = "/home/${secrets.ssh.config.acorn.user}";
      trashcli = "trash";
    };

    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 5; # max number of previous system builds in bootloader
    };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.timeout = 0; # hold space during boot to see boot selection menu

    networking.hostName = "acorn";
    networking = {
      interfaces.enp0s1 = {
        useDHCP = false;
	      ipv4.addresses = [ {
	        address = ${secrets.ssh.config.acorn.ip};
	        prefixLength = 24;
	      } ];
      };
      defaultGateway = {
        address = "192.168.64.1";
	      interface = "enp0s1";
      };
      nameservers = [ "1.1.1.1" "1.0.0.1" ];
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
