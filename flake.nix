{
  description = "Nix config for personal infrastructure";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { ... }@inputs: with inputs;
  let
    inherit (self) outputs;
    stateVersion = "24.11";
  in
  {
    nixosConfigurations.latitude = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        ({ pkgs, ... }: {
          nixpkgs = { overlays = [(self: super: { unstable = import nixpkgs-unstable { system = "x86_64-linux"; }; }) ]; };
        })
        ./hosts/nixos/latitude/configuration.nix 
      ];
    };

    nixosConfigurations.testvm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
      ./hosts/nixos/testvm/configuration.nix 
        ({ pkgs, ... }: {
          nixpkgs = { overlays = [(self: super: { unstable = import nixpkgs-unstable { system = "x86_64-linux"; }; }) ]; };
        })
      ];
    };
  };
}
