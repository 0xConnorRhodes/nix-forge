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
        workbench.startupEditor = "none"; # don't show startup screen
        update.mode = "none";
        files.autoSave = "afterDelay";
        editor.fontFamily = "'JetBrainsMono Nerd Font', 'monospace', monospace";
        editor = {
          tabSize = 2;
          minimap.enabled = false;
          formatOnSave = true;
          defaultFormatter = "null";
        };
        explorer = {
          confirmDragAndDrop = false;
          confirmDelete = false;
        };
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
