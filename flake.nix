{
  description = "Nix config for personal infrastructure";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
    homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs"; # ensure package versions are the same as nixpkgs (eg. 24.11)
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
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
        # pkgs = import inputs.nixpkgs { system = system; config.allowUnfree = true;};
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
          inputs.nix-index-database.nixosModules.nix-index
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
  }; # end outputs
}
