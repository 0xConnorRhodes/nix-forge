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

    # { key = "cmd+k j";
    #   command = "workbench.action.previousEditor"; }
    # { key = "cmd+k cmd+j";
    #   command = "workbench.action.previousEditor"; }
    { key = "cmd+u";
      command = "workbench.action.previousEditor"; }

    { key = "cmd+k o";
      command = "workbench.action.quickOpen"; }
    { key = "cmd+k cmd+o";
      command = "workbench.action.quickOpen"; }

    { key = "cmd+k i";
      command = "workbench.action.showAllEditors"; }
    { key = "cmd+k cmd+i";
      command = "workbench.action.showAllEditors"; }

    # cycle through file options in the quickOpen buffer (similar to C-p, C-p in default config)
    { key = "cmd+o";
      command = "workbench.action.quickOpenNavigateNextInFilePicker";
      when = "inFilesPicker && inQuickOpen"; }
  ];
}
