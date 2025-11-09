{ config, osConfig, pkgs, ... }:

{
  programs.lf = {
    enable = true;

    # options normally set with `set option value`
    settings = { };

    keybindings = {
      "." = "set hidden!";
      "<backspace2>" = "trash";
      "E" = "code";
    };

    commands = {
      trash = "\$${osConfig.myConfig.trashcli} \"$fx\"";
      code = "&code \"$f\"";
    };

    previewer.source = pkgs.writeShellScript "preview.sh" ''
      #!/bin/sh

      case "$1" in
        *.md) ${pkgs.bat}/bin/bat --style=plain --color=always --language=markdown --terminal-width=52 --wrap=character "$1";;
        *) ${pkgs.bat}/bin/bat --style=plain --color=always "$1";;
      esac
    '';
  };
}
