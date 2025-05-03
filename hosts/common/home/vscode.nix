{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  programs.vscode = {
    enable = true;
    userSettings = {
      files.autoSave = "afterDelay";
      editor = {
        tabSize = 2;
      };
      explorer = {
        confirmDragAndDrop = false;
        confirmDelete = false;
      };
      github.copilot.enable."*" = false;

      terminal.integrated.profiles.osx = {
        myZsh = {
          path = "zsh";
          args = [
            "-l"
          ];
        };
      };

      terminal.integrated.defaultProfile.osx = "myZsh";
    };
  };
}