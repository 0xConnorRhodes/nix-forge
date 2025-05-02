{config, pkgs, ...}:

{
  programs.lf = {
    enable = true;

    keybindings = {
      "." = "set hidden!";
    };

    previewer.source = pkgs.writeShellScript "preview.sh" ''
      #!/bin/sh

      case "$1" in
        *) ${pkgs.bat}/bin/bat --style=plain --color=always "$1";;
      esac
    '';
  };
}