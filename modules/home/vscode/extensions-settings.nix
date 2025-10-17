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
        enable = {
          "*" = true; # copilot autocomplete in all files
        };
        editor.enableCodeActions = true; # icon to modify/review with copilot on text selection
        advanced.authPermissions = "Grant"; # grant advanced auth permissions for Copilot
      };
      chat.tools.global.autoApprove = true; # auto-approve chat tools for agent mode

      # sumneko.lua
      Lua = {
        window.statusBar = false;
      };

      # ms-python.python
      python = {
        defaultInterpreterPath = "/run/current-system/sw/bin/python";
      };

      # geminicodeassist = {
      #   inlineSuggestions.enableAuto = false;
      #   enableTelemetry = false;
      # };

      # indent-rainbow
      # indentRainbow = {
      #   includedLanguages = [ "python" "yaml" ];
      #   # indicator style: "light"; # light = single line ; classic = full block
      #   indicatorStyle = "light";
      #   lightIndicatorStyleLineWidth = 1;
      #   colors = [
      #     # 0.8 opacity for light, 0.3 for classic
      #     "rgba(255,214,2,0.8)"
      #     "rgba(218,112,214,0.8)"
      #     "rgba(22,159,255,0.8)"
      #     #"rgba(0,252,118,0.8)"
      #   ];
      # };
    };
  };
}
