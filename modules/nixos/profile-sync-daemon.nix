{ config, pkgs, ... }:

let
  psdOverlay = self: super: {
    profile-sync-daemon = super.profile-sync-daemon.overrideAttrs (old: {
      installPhase = ''
        # run the stock installPhase
        ${old.installPhase}

        # create zen file in share/psd/browsers
        mkdir -p $out/share/psd/browsers
        cat > $out/share/psd/browsers/zen <<'EOF'
        if [[ -d "$HOME"/.zen ]]; then
            index=0
            PSNAME="$browser"
            while read -r profileItem; do
                if [[ $(echo "$profileItem" | cut -c1) = "/" ]]; then
                    # path is not relative
                    DIRArr[$index]="$profileItem"
                else
                    # we need to append the default path to give a
                    # fully qualified path
                    DIRArr[$index]="$HOME/.zen/$profileItem"
                fi
                (( index=index+1 ))
            done < <(grep '[Pp]'ath= "$HOME"/.zen/profiles.ini | sed 's/[Pp]ath=//')
        fi

        check_suffix=1
        EOF
      '';
    });
  };
in
{
  # register the overlay
  nixpkgs.overlays = [ psdOverlay ];

  # now profile-sync-daemon in pkgs is our patched one
  environment.systemPackages = with pkgs; [
    profile-sync-daemon
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
