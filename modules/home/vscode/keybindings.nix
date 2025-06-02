{ config, pkgs, inputs, osConfig, ... }:
let
  modAlt = osConfig.myConfig.modAlt;
in
{
  programs.vscode.profiles.default.keybindings = [
    { key = "${modAlt}+j";
      command = "workbench.action.terminal.focus";
      when = "!terminalFocus"; }
    { key = "${modAlt}+j";
      command = "workbench.action.togglePanel";
      when = "terminalFocus"; }

    { key = "${modAlt}+,";
      command = "workbench.panel.chat"; }

    { key = "${modAlt}+b";
      command = "workbench.action.toggleSidebarVisibility"; }

    { key = "${modAlt}+w";
      command = "workbench.action.closeActiveEditor"; }

    { key = "${modAlt}+k k";
      command = "workbench.action.showCommands"; }
    { key = "${modAlt}+k ${modAlt}+k";
      command = "workbench.action.showCommands"; }

    { key = "${modAlt}+k ${modAlt}+e";
      command = "workbench.files.action.focusFilesExplorer"; }
    { key = "${modAlt}+k e";
      command = "workbench.files.action.focusFilesExplorer"; }

    { key = "${modAlt}+u";
      command = "workbench.action.previousEditor"; }
    { key = "${modAlt}+i";
      command = "workbench.action.nextEditor"; }

    { key = "${modAlt}+k o";
      command = "workbench.action.quickOpen"; }
    { key = "${modAlt}+k ${modAlt}+o";
      command = "workbench.action.quickOpen"; }

    { key = "${modAlt}+k i";
      command = "workbench.action.showAllEditors"; }
    { key = "${modAlt}+k ${modAlt}+i";
      command = "workbench.action.showAllEditors"; }

    # cycle through file options in the quickOpen buffer (similar to C-p, C-p in default config)
    { key = "${modAlt}+o";
      command = "workbench.action.quickOpenNavigateNextInFilePicker";
      when = "inFilesPicker && inQuickOpen"; }

  ];
}
