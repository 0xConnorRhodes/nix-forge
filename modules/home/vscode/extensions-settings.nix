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
          "**/*.lua"
        ];
      };

      # sumneko.lua
      Lua = {
        window.statusBar = false;
      };

      # ms-python.python
      python = {
      	defaultInterpreterPath = "/run/current-system/sw/bin/python";
      };

      # yzhang.markdown-all-in-one
      markdown.extension = {
        math.enabled = false;
      };

      # satokaz.vscode-markdown-header-coloring
      markdown-header-coloring = {
        backgroundColor = false;
      };

      geminicodeassist = {
        inlineSuggestions.enableAuto = false;
        enableTelemetry = false;
      };
    };
  };
}
