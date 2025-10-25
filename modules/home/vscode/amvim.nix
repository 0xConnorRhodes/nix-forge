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
      key = "w";
      command = "cursorWordRight";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    {
      key = "b";
      command = "cursorWordLeft";
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
  ];
}
