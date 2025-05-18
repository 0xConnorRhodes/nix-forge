{ config, pkgs, pkgsUnstable, inputs, secrets, ... }:
{
  environment.systemPackages = [ pkgs.authelia ];

  services.authelia.instances.homelab = {
    enable = true;
    package = pkgs.authelia;
    secrets = {
      jwtSecretFile = "/etc/authelia/jwtSecretFile";
      storageEncryptionKeyFile = "/etc/authelia/storageEncryptionKeyFile";
    };
  };

  environment.etc."authelia/jwtSecretFile" = {
    mode = "0400";
    user = "authelia-homelab";
    text = "a_very_important_secret";
  };

  environment.etc."authelia/storageEncryptionKeyFile" = {
    mode = "0400";
    user = "authelia-homelab";
    text = "you_must_generate_a_random_string_of_more_than_twenty_chars_and_configure_this";
  };
}