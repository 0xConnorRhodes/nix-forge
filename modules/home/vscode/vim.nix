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
    easymotion = true; # \ss
    incsearch = true;

    insertModeKeyBindings = [
      { before = ["k" "j"];
        after = ["<Esc>"]; }
    ];

    normalModeKeyBindingsNonRecursive = [
      { before = ["Y"];
        after = ["y" "$"]; }

      { before = ["leader" "e"];
        commands = ["workbench.action.toggleSidebarVisibility"]; }

      { before = ["leader" "s" "g"];
        commands = ["workbench.action.findInFiles"]; }

      { before = ["leader" "f" "f"];
        commands = ["workbench.action.quickOpen"]; }

      # shows only actively open editors (buffers)
      # equivalent to typing 'edt ' in the quickOpen menu
      { before = ["leader" " "];
        commands = ["workbench.action.showAllEditors"]; }

      { before = ["leader" "f" "d"];
        commands = ["workbench.action.quickOpen"]; }

      { before = ["leader" "b" "d"];
        commands = ["workbench.action.closeActiveEditor"]; }

      { before = ["leader" "j"];
        commands = ["workbench.action.previousEditor"]; }

      { before = ["leader" "k"];
        commands = ["workbench.action.showCommands"]; }

      { before = ["leader" "o"];
        commands = ["workbench.action.quickOpen"]; }

      # leader b X changes what the sidebar shows. C-b toggles the sidebar
      { before = ["leader" "b" "e"];
        # commands = ["workbench.action.toggleSidebarVisibility"]; }
        commands = ["workbench.view.explorer"]; }

      { before = ["<C-l>"];
        after = [":" "n" "o" "h" "l" "<CR>"]; }

      { before = ["<Enter>"];
        commands = ["editor.toggleFold"]; }

      { before = ["leader" "|"];
        commands = [":vsplit"]; }

      { before = ["leader" "-"];
        commands = [":split"]; }

      # Go to beginning and end of line with gh and gl
      { before = ["g" "h"];
        commands = ["cursorHome"]; }

      { before = ["g" "l"];
        commands = ["cursorEnd"]; }
    ];
  };
}
