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
  ];
}
