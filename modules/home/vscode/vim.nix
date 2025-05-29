# settings for the vscodevim.vim extension
{ config, ... }:

{
  programs.vscode.profiles.default.userSettings.vim = {
    leader = "<Space>";
    # leader = " ";
    hlsearch = true;
    useCtrlKeys = true;
    useSystemClipboard = true;
    foldfix = true; # don't unfold as you j/k through a folded heading

    normalModeKeyBindingsNonRecursive = [
      { before = ["Y"]; 
        after = ["y" "$"]; }

      { before = ["leader" "s" "g"];
        commands = ["workbench.action.findInFiles"]; }

      # leader b X changes what the sidebar shows. C-b toggles the sidebar
      { before = ["leader" "b" "e"];
        # commands = ["workbench.action.toggleSidebarVisibility"]; }
        commands = ["workbench.view.explorer"]; }
    ];
  };
}