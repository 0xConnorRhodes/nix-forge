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

      # shows only actively open editors (buffers)
      # equivalent to typing 'edt ' in the quickOpen menu
      { before = ["leader" " "];
        commands = ["workbench.action.showAllEditors"]; }

      { before = ["leader" "f" "d"];
        commands = ["workbench.action.quickOpen"]; }

      { before = ["leader" "b" "d"];
        commands = ["workbench.action.closeActiveEditor"]; }

      { before = ["leader" "k"];
        commands = ["workbench.action.showCommands"]; }

      { before = ["leader" "o"];
        commands = ["workbench.action.quickOpen"]; }

      # leader b X changes what the sidebar shows. C-b toggles the sidebar
      { before = ["leader" "b" "e"];
        # commands = ["workbench.action.toggleSidebarVisibility"]; }
        commands = ["workbench.view.explorer"]; }

      { before = ["leader" "j"];
        commands = ["workbench.action.previousEditor"]; }

      { before = ["<C-l>"];
        after = [":" "n" "o" "h" "l" "<CR>"]; }
    ];
  };
}
