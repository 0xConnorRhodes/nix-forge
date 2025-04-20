{ inputs, config, ... }:
let
  username = config.myConfig.username;
in
{
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

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

  services.bpftune.enable = true;
  programs.nix-ld.enable = true;

}
