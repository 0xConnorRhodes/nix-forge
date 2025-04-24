{
  description = "Nix config for personal infrastructure";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";

    nix-darwin.url = "github:lnl7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs"; # ensure package versions are the same as nixpkgs (eg. 24.11)
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
  let
    secrets = builtins.fromJSON (builtins.readFile ./secrets.json);
  in
  {
    nixosConfigurations = {

      mpro = nixpkgs.lib.nixosSystem rec {
        specialArgs = { inherit inputs; inherit secrets; };
        system = "x86_64-linux";
        modules = [ 
          ./hosts/nixos/mpro/configuration.nix 
	        inputs.home-manager.nixosModules.default
        ];
      };

      latitude = nixpkgs.lib.nixosSystem rec {
        specialArgs = { inherit inputs; inherit secrets; };
        system = "x86_64-linux";
        modules = [ 
          ./hosts/nixos/latitude/configuration.nix 
	        inputs.home-manager.nixosModules.default
          inputs.nixos-hardware.nixosModules.dell-latitude-5490
        ];
      };

      testvm = nixpkgs.lib.nixosSystem rec {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [ 
          ./hosts/nixos/testvm/configuration.nix 
	        inputs.home-manager.nixosModules.default
        ];
      };

    }; # end nixosConfigurations
  
    darwinConfigurations = {
      traveller = inputs.nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        pkgs = import inputs.nixpkgs { system = "aarch64-darwin"; };
        modules = [
          ({ pkgs, ... }: {
            nix.extraOptions = ''
              experimental-features = nix-command flakes
            '';
            system.stateVersion = 5; # from initial install, needed for backward compatibility
            services.nix-daemon.enable = true; # allow nix-darwin to manage and update nix-daemon
            system.defaults.finder.AppleShowAllExtensions = true; # show file extensions in finder
            system.defaults.finder._FXShowPosixPathInTitle = true;
            system.keyboard.enableKeyMapping = true;
            system.keyboard.remapCapsLockToControl = true;
            system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
            system.defaults.NSGlobalDomain.KeyRepeat = 3;
          })
        ];
      };
    }; # end darwinConfigurations
  }; # end outputs
}
