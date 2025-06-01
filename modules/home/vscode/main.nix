{ config, pkgs, inputs, ... }:
let
  myZshProfile = {
    path = "zsh";
    args = [
      "-l"
    ];
  };
in
{
  imports = [
    ./keybindings.nix
    ./extensions-list.nix
    ./extensions-settings.nix
    ./vim.nix
  ];

  nixpkgs.config.allowUnfree = true;
  programs.vscode = {
    enable = true;
    profiles.default = {
      enableUpdateCheck = false;
      userSettings = {
        workbench = {
          startupEditor = "none"; # don't show startup screen
	        trustedDomains.promptInTrustedWorkspace = false;
          activityBar.location = "hidden";

          # hide things
          statusBar.visible = true;
          showTabs = false;
          editor.showTabs = "none";
        };

        window = {
          newWindowDimensions = "inherit";

          # disable vscode title bar and replace with OS native bar (smaller)
          titleBarStyle = "native";
          customTitleBarVisibility = "never";

          # zoomLevel = 0; # default zoom level, set in home.nix
        };

        editor = {
          scrollbar.verticalScrollbarSize = 6;
          scrollbar.horizontalScrollbarSize = 5;
          fontFamily = "'JetBrainsMono Nerd Font', 'monospace', monospace";
          tabSize = 2;

          # reduce gutter (left margin padding) size
          glyphMargin = false;
          showFoldingControls = "never";

          formatOnSave = true;
          copyWithSyntaxHighlighting = false; # copy as plain text
          defaultFormatter = "null";
          emptySelectionClipboard = false; # don't copy current line if C-c pressed with no selection
          snippetSuggestions = "top"; # snippet suggestions first in autocomplete list

          stickyScroll.enabled = false;
          enablePreview = false; # open new files in main buffer, not preview buffer
          minimap.enabled = false;
          renderIndentGuides = true;
          lineNumbers = "on";
        };

        diffEditor = {
          ignoreTrimWhitespace = true; # don't count whitespace as a difference in diff view
        };

        files = {
          autoSave = "afterDelay";
          insertFinalNewline = true;
          trimFinalNewlines = true; # trim trailing newlines (apart from the 1 added above)
          trimTrailingWhitespace = true; # trim trailing whitespace at the end of a line
        };

        explorer = {
          confirmDragAndDrop = false;
          confirmDelete = false;
        };

        breadcrumbs.enabled = false;
        update.mode = "none";
        security.workspace.trust.emptyWindow = true;
        git.openRepositoryInParentFolders = "never";

        github.copilot = {
          enable."*" = false; # disable copilot autocomplete
          editor.enableCodeActions = false; # icon to modify/review with copilot on text selection
        };

        terminal.integrated.profiles.osx = {
          myZsh = myZshProfile;
        };

        terminal.integrated.defaultProfile = {
          linux = "myZsh";
          osx = "myZsh";
        };
      };
    };
  };
}
