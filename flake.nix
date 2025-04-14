{
  description = "Nix config for personal infrastructure";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

  };

  outputs = { ... }@inputs: with inputs;
  let
    inherit (self) outputs;
  in
  {
    nixosConfigurations = {

      latitude = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ({ pkgs, ... }: {
            nixpkgs = { overlays = [(self: super: { unstable = import nixpkgs-unstable { system = "x86_64-linux"; }; }) ]; };
          })
          ./hosts/nixos/latitude/configuration.nix 
        ];
      };

      testvm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ({ pkgs, ... }: {
            nixpkgs = { overlays = [(self: super: { unstable = import nixpkgs-unstable { system = "x86_64-linux"; }; }) ]; };
          })
          ./hosts/nixos/testvm/configuration.nix 
        ];
      };

    }; # end nixosConfigurations
  }; # end outputs
}
