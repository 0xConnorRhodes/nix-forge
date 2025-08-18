{ config, lib, pkgs, inputs, osConfig, ... }:

{
  programs.vscode.profiles.default = {
    enableExtensionUpdateCheck = false;
    # per-extension settings (comment shows extension ID)
    userSettings = {
      extensions.autoCheckUpdates = false;
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


      # GitHub Copilot
      github.copilot = {
        enable."*" = true; # copilot autocomplete
        editor.enableCodeActions = true; # icon to modify/review with copilot on text selection
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

      # geminicodeassist = {
      #   inlineSuggestions.enableAuto = false;
      #   enableTelemetry = false;
      # };

      # workbench.colorCustomizations = {
      #   editor.lineHighlightBorder = "#9fced11f";
      #   editor.lineHighlightBackground = "#1073cf2d";
      # };
    };
  };
}
