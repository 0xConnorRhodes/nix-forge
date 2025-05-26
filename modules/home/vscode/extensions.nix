{ config, pkgs, inputs, ... }:

{
  programs.vscode = {
    profiles.default = {
      userSettings = {
        extensions.autoCheckUpdates = false;
      };
      enableExtensionUpdateCheck = false;
    };
  };
}