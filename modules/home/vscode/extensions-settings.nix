{ config, pkgs, inputs, osConfig, ... }:

{
  programs.vscode.profiles.default = {
    enableExtensionUpdateCheck = false;
    userSettings.extensions.autoCheckUpdates = false;
    # per-extension settings (comment shows extension ID)
    userSettings = {

      simple-project-switcher.directory = osConfig.myConfig.homeDir+"/code";

      # redhat.vscode-yaml
      redhat.telemetry.enabled = true; # YAML extension

      # jgclark.vscode-todo-highlight
      todohighlight = {
        include = [
          "**/*.html"
          "**/*.css"
          "**/*.rb"
          "**/*.md"
          "**/*.yml"
        ];
      };

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
