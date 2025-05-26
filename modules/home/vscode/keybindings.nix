{ config, pkgs, inputs, ... }:

{
  programs.vscode.profiles.default.keybindings = [
    {
      key = "cmd+j";
      command = "workbench.action.terminal.toggleTerminal";
      when = "workbench.action.terminal.toggleTerminal";
    }
  ];
}