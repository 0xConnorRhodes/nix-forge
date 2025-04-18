{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {

    # caps => control
    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us" ]) ];
      xkb-options = [ "caps:ctrl_modifier" ];
    };

    # keyboard config
    "org/gnome/desktop/peripherals/keyboard" = {
      delay = mkUint32 200; # delay before keys repeat
      numlock-state = false;
    };

    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      enable-hot-corners = false;
    };

    # enable do not disturb
    "org/gnome/desktop/notifications" = {
      application-children = [ "org-gnome-console" "gnome-power-panel" "org-gnome-nautilus" ];
      show-banners = false;
    };

    # enable window snapping
    "org/gnome/mutter" = {
      edge-tiling = true;
    };

  };
}
