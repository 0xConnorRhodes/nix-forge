{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (profile-sync-daemon.overrideAttrs (old: {

      src = pkgs.fetchFromGitHub {
        owner = "graysky2";
        repo = "profile-sync-daemon";
        rev = "cd8c2a37f152bd2bde167a0e066085ac23bc17d9";
        hash = "sha256-+4VHOJryoNodJvx5Ug2TX7/T3OsFW5VwxaL9WUcp8xA=";
      };

      installPhase = (old.installPhase or "") + ''
        cp $out/share/psd/contrib/zen $out/share/psd/browsers/zen
      '';

      # postInstall = (old.postInstall or "") + ''
      #   # create zen file in share/psd/browsers
      #   mkdir -p $out/share/psd/browsers
      #   cat > $out/share/psd/browsers/zen <<'EOF'
      #   if [[ -d "$HOME"/.zen ]]; then
      #       index=0
      #       PSNAME="$browser"
      #       while read -r profileItem; do
      #           if [[ $(echo "$profileItem" | cut -c1) = "/" ]]; then
      #               # path is not relative
      #               DIRArr[$index]="$profileItem"
      #           else
      #               # we need to append the default path to give a
      #               # fully qualified path
      #               DIRArr[$index]="$HOME/.zen/$profileItem"
      #           fi
      #           (( index=index+1 ))
      #       done < <(grep '[Pp]'ath= "$HOME"/.zen/profiles.ini | sed 's/[Pp]ath=//')
      #   fi

      #   check_suffix=1
      #   EOF
      # '';
    }))
  ];

  home-manager.users.${config.myConfig.username} = {
    home.file.".config/psd/psd.conf".text = ''
      # docs: https://wiki.archlinux.org/index.php/Profile-sync-daemon

      ## NOTE the following:
      ## To protect data from corruption, in the event that you do make an edit while
      ## psd is active, any changes made will be applied the next time you start psd.

      USE_OVERLAYFS="yes" # requires kernel 3.18+ psd automatically selects the relevant module, verify working with `psd preview`

      USE_SUSPSYNC="no"

      # list browsers from `/nix/$psd/share/psd/browsers` in BROWSERS array
      # example: BROWSERS=(firefox google-chrome vivaldi)
      BROWSERS=(zen)

      USE_BACKUPS="yes"
      BACKUP_LIMIT=5
    '';
  };
}
