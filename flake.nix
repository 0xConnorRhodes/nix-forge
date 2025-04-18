{
  description = "Nix config for personal infrastructure";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs"; # ensure package versions are the same as nixpkgs (eg. 24.11)
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs:
  {
    nixosConfigurations = {

      latitude = nixpkgs.lib.nixosSystem rec {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [ 
          ({ pkgs, ... }: {
            nixpkgs = { overlays = [(self: super: { unstable = import nixpkgs-unstable { system = system; }; }) ]; };
          })
          ./hosts/nixos/latitude/configuration.nix 
	  inputs.home-manager.nixosModules.default
        ];
      };

      testvm = nixpkgs.lib.nixosSystem rec {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [ 
          ({ pkgs, ... }: {
            nixpkgs = { overlays = [(self: super: { unstable = import nixpkgs-unstable { system = system; }; }) ]; };
          })
          ./hosts/nixos/testvm/configuration.nix 
        ];
      };

    }; # end nixosConfigurations
  }; # end outputs
}
