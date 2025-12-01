{ config, secrets, lib, pkgs, ... }:

{
  programs.rbw = {
    enable = true;
  };

  # manually write settings to ensure the correct pinentry path (home manager module deprecated setting pinentry via `settings`)
  home.file."${if pkgs.stdenv.isDarwin then "Library/Application Support/rbw/config.json" else ".config/rbw/config.json"}".text = builtins.toJSON {
    email = secrets.bitwarden.email;
    base_url = secrets.bitwarden.base_url;
    lock_timeout = secrets.bitwarden.lock_timeout;
    sync_interval = secrets.bitwarden.sync_interval;
    pinentry = "${pkgs.pinentry-curses}/bin/pinentry-curses";
  };
}
