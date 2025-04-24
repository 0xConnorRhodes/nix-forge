rebuild:
	sudo nixos-rebuild switch --flake .

darwin:
	nix --extra-experimental-features "nix-command flakes" build .#darwinConfigurations.traveller.system
