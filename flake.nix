{
  description = "Nix config for personal infrastructure";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
    homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };


    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

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

    # flakePackages
    json2nix = {
      url = "github:sempruijs/json2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
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
          { home-manager.extraSpecialArgs = specialArgs; } # needed to access inputs in home.nix
        ];
      };

      latitude = nixpkgs.lib.nixosSystem rec {
        specialArgs = { inherit inputs; inherit secrets; };
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos/latitude/configuration.nix
	        inputs.home-manager.nixosModules.default
          { home-manager.extraSpecialArgs = specialArgs; } # needed to access inputs in home.nix
          inputs.nixos-hardware.nixosModules.dell-latitude-5490
        ];
      };

      thinkpad = nixpkgs.lib.nixosSystem rec {
        specialArgs = { inherit inputs; inherit secrets; };
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos/thinkpad/configuration.nix
	        inputs.home-manager.nixosModules.default
          { home-manager.extraSpecialArgs = specialArgs; } # needed to access inputs in home.nix
        ];
      };

      vostro = nixpkgs.lib.nixosSystem rec {
        specialArgs = { inherit inputs; inherit secrets; };
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos/vostro/configuration.nix
	        inputs.home-manager.nixosModules.default
          { home-manager.extraSpecialArgs = specialArgs; } # needed to access inputs in home.nix
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
