# settings for the vscodevim.vim extension
{ config, ... }:

{
  programs.vscode.profiles.default.userSettings.vim = {
    leader = "<Space>";
    hlsearch = true;
    useCtrlKeys = true;
    useSystemClipboard = true;
    foldfix = true; # don't unfold as you j/k through a folded heading

    normalModeKeyBindingsNonRecursive = [
      { before = ["Y"]; after = ["y" "$"]; }
    ];
  };
}