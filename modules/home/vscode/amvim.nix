# settings for the amVim extension
{ config, ... }:

{
  programs.vscode.profiles.default.userSettings.amVim = {
    useSystemClipboard = true;
  };

  programs.vscode.profiles.default.keybindings = [
    {
      key = "j";
      command = "cursorDown";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    {
      key = "k";
      command = "cursorUp";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    {
      key = "enter";
      command = "editor.toggleFold";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    {
      # note, the cursorUndo command only works as expected if you pause before Y
      # there appears to be a timeout before vscode registors the cursor position
      key = "shift+y";
      command = "runCommands";
      args = {
        commands = [
          "cursorEndSelect"
          "editor.action.clipboardCopyAction"
          "cursorUndo"
        ];
      };
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    {
      key = "g h";
      command = "cursorHome";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    {
      key = "g l";
      command = "cursorEnd";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    {
      key = "k j";
      command = "amVim.escape";
      when = "editorTextFocus && amVim.mode == 'INSERT'";
    }
    {
      key = "space b d";
      command = "workbench.action.closeActiveEditor";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    {
      key = "space space";
      command = "workbench.action.showAllEditors";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    {
      key = "g g";
      command = "cursorTop";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
  ];
}
