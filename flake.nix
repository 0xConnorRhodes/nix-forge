{
  description = "Nix config for personal infrastructure";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {

    nixosConfigurations.latitude = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./hosts/nixos/latitude/configuration.nix ];
    };

    nixosConfigurations.testvm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./hosts/nixos/testvm/configuration.nix ];
    };

  };
}
