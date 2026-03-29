{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "nothing";
      sleep-inactive-ac-type = "nothing";
    };
  };
}
