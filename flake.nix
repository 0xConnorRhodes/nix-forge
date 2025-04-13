{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };
  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.testvm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        ./hosts/nixos/testvm/configuration.nix
      ];
    };
  };
}
