{ config, pkgs, inputs, ... }:

{
  programs.vscode.profiles.default.keybindings = [
    { key = "cmd+j";
      command = "workbench.action.terminal.toggleTerminal";
      when = "workbench.action.terminal.toggleTerminal"; }

    { key = "cmd+k k";
      command = "workbench.action.showCommands"; }

    { key = "cmd+k cmd+k";
      command = "workbench.action.showCommands"; }
  ];
}