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
          statusBar.visible = false;
          editor.enablePreview = false; # open new files in main buffer, not preview buffer
        };

        window = {
          newWindowDimensions = "inherit";
          # nativeFullScreen = false; # don't use macOS native fullscreen
        };

        editor = {
          fontFamily = "'JetBrainsMono Nerd Font', 'monospace', monospace";
          tabSize = 2;
          minimap.enabled = false;
          formatOnSave = true;
          copyWithSyntaxHighlighting = false; # copy as plain text
          defaultFormatter = "null";
          emptySelectionClipboard = false; # don't copy current line if C-c pressed with no selection
          snippetSuggestions = "top"; # snippet suggestions first in autocomplete list
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

        update.mode = "none";
        security.workspace.trust.emptyWindow = true;
        github.copilot.enable."*" = false;
        git.openRepositoryInParentFolders = "never";

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
