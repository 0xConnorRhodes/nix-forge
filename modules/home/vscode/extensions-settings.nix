{ config, pkgs, inputs, ... }:

{
  programs.vscode.profiles.default = {
    enableExtensionUpdateCheck = false;
    userSettings.extensions.autoCheckUpdates = false;
    # per-extension settings (comment shows extension ID)
    userSettings = {
      # redhat.vscode-yaml
      redhat.telemetry.enabled = true; # YAML extension

      # sumneko.lua
      Lua = {
        window.statusBar = false;
      };

      # yzhang.markdown-all-in-one
      markdown.extension = {
        math.enabled = false;
      };

      # satokaz.vscode-markdown-header-coloring
      markdown-header-coloring = {
        backgroundColor = false;
      };
    };
  };
}