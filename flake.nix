{
  description = "Nix monorepo for personal infrastructure";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
    homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs"; # ensure package versions are the same as nixpkgs (eg. 25.05)
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # flakePackages
    json2nix = {
      url = "github:sempruijs/json2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pinned-hugo = {
      url = "github:nixos/nixpkgs/3c66daa779d7cca11d3ee15d8da9b4bb76ed60ee";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-generators, pinned-hugo, ... }@inputs:
  let
    secrets = builtins.fromJSON (builtins.readFile ./.secrets.json);
  in
  {
    nixosConfigurations = {

      mpro = nixpkgs.lib.nixosSystem rec {
        specialArgs = { inherit inputs; inherit secrets; };
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos/mpro/configuration.nix
	        inputs.home-manager.nixosModules.default
          {
            home-manager.extraSpecialArgs = specialArgs; # needed to access inputs in home.nix
            home-manager.sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
          }
        ];
      };

      thinkpad = nixpkgs.lib.nixosSystem rec {
        specialArgs = { inherit inputs; inherit secrets; };
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos/thinkpad/configuration.nix
	        inputs.home-manager.nixosModules.default
          {
            home-manager.extraSpecialArgs = specialArgs; # needed to access inputs in home.nix
            home-manager.sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
          }
        ];
      };

      # ARM dev vm
      acorn = nixpkgs.lib.nixosSystem rec {
        specialArgs = { inherit inputs; inherit secrets; };
        system = "aarch64-linux";
        modules = [
          ./hosts/acorn/configuration.nix
          inputs.home-manager.nixosModules.default
          {
            home-manager.extraSpecialArgs = specialArgs; # needed to access inputs in home.nix
          }
        ];
      };

      media = nixpkgs.lib.nixosSystem rec {
        specialArgs = { inherit inputs; inherit secrets; };
        system = "aarch64-linux";
        modules = [
          ./hosts/nixos/media/configuration.nix
          inputs.home-manager.nixosModules.default
          {
            home-manager.extraSpecialArgs = specialArgs; # needed to access inputs in home.nix
            home-manager.sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
          }
        ];
      };
    }; # end nixosConfigurations

    darwinConfigurations = {
      traveller = inputs.nix-darwin.lib.darwinSystem rec {
        specialArgs = { inherit inputs; inherit secrets; };
        system = "aarch64-darwin";
        # needed to install nonfree licensed software with home-manager
        pkgs = import inputs.nixpkgs { system = system; config.allowUnfree = true;};
        modules = [
          ./hosts/darwin/traveller/darwin-config.nix
          inputs.home-manager.darwinModules.home-manager
          inputs.nix-homebrew.darwinModules.nix-homebrew
        ];
      };
    }; # end darwinConfigurations
    # end nixosConfigurations

    # Image generation for Raspberry Pi
    packages.aarch64-linux.media-image = nixos-generators.nixosGenerate {
      system = "aarch64-linux";
      specialArgs = { inherit inputs; inherit secrets; };
      modules = [
        ./hosts/nixos/media/configuration.nix
        inputs.home-manager.nixosModules.default
        {
          home-manager.extraSpecialArgs = { inherit inputs; inherit secrets; };
          home-manager.sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
        }
        # Override problematic default modules
        {
          boot.initrd.availableKernelModules = nixpkgs.lib.mkForce [
            "usbhid" "usb_storage" "vc4" "pcie_brcmstb" "reset-raspberrypi"
            "bcm2835_dma" "i2c_bcm2835" "spi_bcm2835" "pwm_bcm2835"
            "sd_mod" "ext4" "crc32c" "libcrc32c" "crc32c_generic"
          ];
          # Override filesystem configuration for SD image
          fileSystems."/" = nixpkgs.lib.mkForce {
            device = "/dev/disk/by-label/NIXOS_SD";
            fsType = "ext4";
          };
          fileSystems."/boot/firmware" = nixpkgs.lib.mkForce {
            device = "/dev/disk/by-label/FIRMWARE";
            fsType = "vfat";
            options = [ "nofail" "noauto" ];
          };
        }
      ];
      format = "sd-aarch64";
    };
  }; # end outputs
}
