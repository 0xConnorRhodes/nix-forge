# home.nix

{ pkgs, inputs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.main = {
      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "nxp" ];
        };
      };
      search.force = true;

      # https://discourse.nixos.org/t/firefox-import-html-bookmark-file-in-a-declarative-manner/38168/23
      bookmarks = {
        settings = [];
        force = true; # override existing bookmarks
      };

      settings = { # from about:config
        # "dom.security.https_only_mode" = true;
        browser = {
          aboutwelcome.didSeeFinalScreen = true;
          aboutConfig.showWarning = false;
          download.panel.shown = false;
          startup.homepage = "https://home.connorrhodes.com";
          newtabpage.enabled = false;
        };
        identity.fxaccounts.enabled = false;
        trailhead.firstrun.didSeeAboutWelcome = true;
        toolkit.telemetry.reportingpolicy.firstRun = false;
        sidebar.visibility = "hide-sidebar";
        signon.rememberSignons = false;
      };

      # userChrome = ''
      #   /* some css */
      # '';

      # extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
      #   bitwarden
      #   ublock-origin
      #   sponsorblock
      #   darkreader
      #   tridactyl
      #   youtube-shorts-block
      # ];
    };
  };
}
