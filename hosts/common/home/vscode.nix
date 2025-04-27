{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    userSettings = {
      files.autoSave = "afterDelay";
      editor = {
        tabSize = 2;
      };
      explorer.confirmDragAndDrop = false;
      github.copilot.enable."*" = false;
    };
  };
}