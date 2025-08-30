{ pkgs, inputs, ... }:
let
  nur = import inputs.nur {
    nurpkgs = pkgs;
    pkgs = pkgs;
  };
in
{
  programs.firefox = {
    enable = true;
    profiles.main = {
      # Firefox extensions
      extensions = {
        force = true; # override existing extensions
        packages = with nur.repos.rycee.firefox-addons; [
          ublock-origin
        ];
      };

      settings = { # from about:config
        # "dom.security.https_only_mode" = true;
        "browser.aboutwelcome.didSeeFinalScreen" = true;
        "browser.aboutConfig.showWarning" = false;
        "browser.download.panel.shown" = false;
        "browser.newtabpage.enabled" = false;
        "browser.bookmarks.addedImportButton" = false; # remove the "Import bookmarks" button from bookmarks toolbar
        "identity.fxaccounts.enabled" = false;
        "trailhead.firstrun.didSeeAboutWelcome" = true;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "sidebar.visibility" = "hide-sidebar";
      };
    };
  };
}
