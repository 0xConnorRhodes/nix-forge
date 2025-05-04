{ pkgs, config, ... }:

{
services.syncthing = {
  enable = true;
  openDefaultPorts = true;
  # Optional: GUI credentials (can be set in the browser instead if you don't want plaintext credentials in your configuration.nix file)
  # or the password hash can be generated with "syncthing generate --config <path> --gui-password=<password>"
  settings.gui = {
    user = "myuser";
    password = "mypassword";
  };
};
systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder
}