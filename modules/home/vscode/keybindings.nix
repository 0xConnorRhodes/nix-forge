{ config, pkgs, inputs, osConfig, ... }:
let
  modAlt = osConfig.myConfig.modAlt;
  modCtrl = osConfig.myConfig.modCtrl;
in
{
  programs.vscode.profiles.default.keybindings = [
    { key = "${modAlt}+j";
      command = "workbench.action.terminal.focus";
      when = "!terminalFocus"; }
    { key = "${modAlt}+j";
      command = "workbench.action.togglePanel";
      when = "terminalFocus"; }

    # toggle right-side panel (chat/other custom elements)
    { key = "${modAlt}+,";
      command = "workbench.action.toggleAuxiliaryBar"; }

    # toggle bar
    { key = "${modAlt}+b";
      command = "workbench.action.toggleSidebarVisibility"; }

    # hack to bounce focus to panel and back to allow toggling panel when terminal is focused
    {
      key = "${modAlt}+b";
      command = "runCommands";
      when = "terminalFocus";
      args = {
        # The list of commands to execute in sequence
        commands = [
          "workbench.action.focusActiveEditorGroup"
          "workbench.action.toggleSidebarVisibility"
          "workbench.action.terminal.focus"
        ];
      };
    }

    # same as previous task, but re-maximizes terminal if it was previously maximized
    {
      key = "${modAlt}+b";
      command = "runCommands";
      when = "terminalFocus && panelMaximized";
      args = {
        commands = [
          "workbench.action.focusActiveEditorGroup"
          "workbench.action.toggleSidebarVisibility"
          "workbench.action.terminal.focus"
          "workbench.action.toggleMaximizedPanel"
        ];
      };
    }

    { key = "${modAlt}+e";
      command = "workbench.action.toggleMaximizeEditorGroup";
      when = "editorPartMaximizedEditorGroup || editorPartMultipleEditorGroups"; }
    { key = "${modAlt}+e";
      command = "workbench.action.toggleMaximizedPanel";
      when = "panelVisible && panelFocus"; }

    { key = "${modCtrl}+i";
      command = "workbench.action.toggleMaximizeEditorGroup";
      when = "editorPartMaximizedEditorGroup || editorPartMultipleEditorGroups"; }
    { key = "${modCtrl}+i";
      command = "workbench.action.toggleMaximizedPanel";
      when = "panelVisible && panelFocus"; }

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

    { key = "${modAlt}+k ${modAlt}+l";
      command = "workbench.action.splitEditor"; }
    { key = "${modAlt}+k l";
      command = "workbench.action.splitEditor"; }

    { key = "${modAlt}+k j";
      command = "workbench.action.splitEditorDown"; }
    { key = "${modAlt}+k ${modAlt}+j";
      command = "workbench.action.splitEditorDown"; }

    { key = "${modAlt}+k x";
      command = "workbench.action.closeEditorsAndGroup"; }
    { key = "${modAlt}+k ${modAlt}+x";
      command = "workbench.action.closeEditorsAndGroup"; }

    # cycle through file options in the quickOpen buffer (similar to C-p, C-p in default config)
    { key = "${modAlt}+o";
      command = "workbench.action.quickOpenNavigateNextInFilePicker";
      when = "inFilesPicker && inQuickOpen"; }

    # vim-style split navigation
    { key = "${modCtrl}+l";
      command = "workbench.action.focusRightGroup"; }
    { key = "${modCtrl}+h";
      command = "workbench.action.focusLeftGroup"; }
    { key = "${modCtrl}+j";
      command = "workbench.action.focusBelowGroup"; }
    { key = "${modCtrl}+k";
      command = "workbench.action.focusAboveGroup"; }

    { key = "${modCtrl}+k";
      command = "workbench.action.focusActiveEditorGroup";
      when = "panelVisible && panelFocus"; }

    { key = "${modAlt}+k n";
      command = "inlineChat.start"; }
    { key = "${modAlt}+k ${modAlt}+n";
      command = "inlineChat.start"; }

    { key = "${modAlt}+k v f"; # view, files
      command = "workbench.view.explorer"; }

    { key = "${modAlt}+k v e"; # view, extensions
      command = "workbench.view.extensions"; }

    { key = "${modAlt}+k v k"; # view, keybinds
      command = "workbench.action.openGlobalKeybindings"; }

    { key = "${modAlt}+k v s"; # view, settings
      command = "workbench.action.openSettings2"; }

    { key = "${modAlt}+k r";
      command = "opensshremotes.openEmptyWindow"; }
  ];
}
