{ config, pkgs, ... }:
let
  myZshProfile = {
    path = "zsh";
    args = [
      "-l"
    ];
  };
in 

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
        myZsh = myZshProfile;
      };

      terminal.integrated.defaultProfile = {
        linux = "myZsh";
        osx = "myZsh";
      };
    };
  };
}