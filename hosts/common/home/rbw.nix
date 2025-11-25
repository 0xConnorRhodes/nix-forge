{ config, lib, pkgs, ... }:

{
  programs.rbw = {
    enable = true;
    settings = {
      email = "connor@rhodes.contact";
      base_url = "https://pass.connorrhodes.com";
      lock_timeout = 36000;
      sync_interval = 3600;
      pinentry = pkgs.pinentry.curses;
    };
  };
}
