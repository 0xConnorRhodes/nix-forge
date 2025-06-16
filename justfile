rebuild:
  sudo nixos-rebuild switch --flake .

dbuild:
  darwin-rebuild switch --flake .#traveller

# darwin stuff
initial-darwin-build:
  nix --extra-experimental-features "nix-command flakes" build .#darwinConfigurations.traveller.system

darwin-bootstrap:
  ./result/sw/bin/darwin-rebuild switch --flake .#traveller

secret:
  yq -o=json secrets.yml > .secrets.json
