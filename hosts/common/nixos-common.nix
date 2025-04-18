{ inputs, config, ... }:
let
  username = config.myConfig.username;
in
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  security.sudo.extraRules = [
    { users = [ username ];
      commands = [
        { command = "ALL" ;
	  options = [ "NOPASSWD" ];
	}
      ];
    }
  ];
}
