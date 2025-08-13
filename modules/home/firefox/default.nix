# home.nix

{ pkgs, inputs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.main = {
      search.engines = {
        "nixpkgs" = {
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

        "home-manager" = {
          urls = [{
            template = "https://home-manager-options.extranix.com/";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "hm" ];
        };
      };
      search.force = true;

      bookmarks = {
        settings = import ./bookmarks.nix;
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
          bookmarks.addedImportButton = false; # remove the "Import bookmarks" button from bookmarks toolbar
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

      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
      ];
    };
  };
}
