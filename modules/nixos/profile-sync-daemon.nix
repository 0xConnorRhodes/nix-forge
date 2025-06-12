{ config, lib, pkgs, ... }:

{
  home-manager.users.${config.myConfig.username} = {
    home.file.".config/psd/psd.conf".text = ''
      # docs: https://wiki.archlinux.org/index.php/Profile-sync-daemon

      ## NOTE the following:
      ## To protect data from corruption, in the event that you do make an edit while
      ## psd is active, any changes made will be applied the next time you start psd.

      USE_OVERLAYFS="yes" # requires kernel 3.18+ psd automatically selects the relevant module, verify working with `psd preview`

      USE_SUSPSYNC="no"

      # List any browsers in the array below to have managed by psd. Useful if you do
      # not wish to have all possible browser profiles managed which is the default if
      # this array is left commented.
      #
      # Possible values:
      #  chromium
      #  chromium-dev
      #  conkeror.mozdev.org
      #  epiphany
      #  falkon
      #  firefox
      #  firefox-trunk
      #  google-chrome
      #  google-chrome-beta
      #  google-chrome-unstable
      #  heftig-aurora
      #  icecat
      #  inox
      #  luakit
      #  midori
      #  opera
      #  opera-beta
      #  opera-developer
      #  opera-legacy
      #  otter-browser
      #  qupzilla
      #  qutebrowser
      #  palemoon
      #  rekonq
      #  seamonkey
      #  surf
      #  vivaldi
      #  vivaldi-snapshot
      #
      #BROWSERS=(firefox google-chrome vivaldi)
      BROWSERS=(vivaldi)

      USE_BACKUPS="yes"
      BACKUP_LIMIT=5
    '';
  };
}
