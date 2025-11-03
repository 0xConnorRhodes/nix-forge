# settings for the amVim extension
{ config, ... }:

{
  programs.vscode.profiles.default.userSettings.amVim = {
    useSystemClipboard = true;
    vimStyleNavigationInListView = false;
  };

  programs.vscode.profiles.default.keybindings = [
    # enabling these allows j and k to move past folds, but horizontal spacing is not preserved
    {
      key = "g j";
      command = "cursorDown";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    {
      key = "g k";
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
      # there appears to be a timeout before vscode registers the cursor position
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
      key = "g g";
      command = "cursorTop";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    {
      key = "space e";
      command = "workbench.action.toggleSidebarVisibility";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    {
      key = "space s g";
      command = "workbench.action.findInFiles";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    # {
    #   key = "space j";
    #   command = "workbench.action.previousEditor";
    #   when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    # }
    # {
    #   key = "space k";
    #   command = "workbench.action.showCommands";
    #   when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    # }
    {
      key = "space o";
      command = "workbench.action.quickOpen";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    {
      key = "space b e";
      command = "workbench.view.explorer";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    {
      key = "space shift+\\";
      command = "workbench.action.splitEditor";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    {
      key = "space -";
      command = "workbench.action.splitEditorDown";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    {
      key = "' '";
      command = "cursorUndo";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    # {
    #   key = ">";
    #   command = "editor.action.indentLines";
    #   when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    # }
    # {
    #   key = "<";
    #   command = "editor.action.outdentLines";
    #   when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    # }
    # {
    #   key = ">";
    #   command = "editor.action.indentLines";
    #   when = "editorTextFocus && amVim.mode == 'VISUAL LINE'";
    # }
    # {
    #   key = "<";
    #   command = "editor.action.outdentLines";
    #   when = "editorTextFocus && amVim.mode == 'VISUAL LINE'";
    # }
    {
      key = "ctrl+d";
      command = "runCommands";
      args = {
        commands = [
          "cursorDown"
          "cursorDown"
          "cursorDown"
          "cursorDown"
          "cursorDown"
          "cursorDown"
          "cursorDown"
          "cursorDown"
          "cursorDown"
          "cursorDown"
          "cursorDown"
          "cursorDown"
          "cursorDown"
          "cursorDown"
          "cursorDown"
        ];
      };
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    {
      key = "ctrl+u";
      command = "runCommands";
      args = {
        commands = [
          "cursorUp"
          "cursorUp"
          "cursorUp"
          "cursorUp"
          "cursorUp"
          "cursorUp"
          "cursorUp"
          "cursorUp"
          "cursorUp"
          "cursorUp"
          "cursorUp"
          "cursorUp"
          "cursorUp"
          "cursorUp"
          "cursorUp"
        ];
      };
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }

    {
      key = "g d";
      command = "editor.action.revealDefinition";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }

    # SPACEMACS-STYLE KEYBINDINGS
    {
      key = "space space";
      # command = "workbench.action.showAllEditors";
      command = "workbench.action.showCommands";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }

    # buffers
    {
      key = "space b b";
      command = "workbench.action.showAllEditors";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    {
      key = "space ,";
      command = "workbench.action.showEditorsInActiveGroup";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    {
      key = "space b d";
      command = "workbench.action.closeActiveEditor";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
    {
      key = "space b shift+d";
      command = "workbench.action.closeOtherEditors";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }

    # files
    {
      key = "space f f";
      command = "workbench.action.quickOpen";
      # this when works both when the editor is open and closed
      when = "(editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput) || (!editorIsOpen && amVim.mode == 'NORMAL' && !amVim.waitingForInput)";
    }
    {
      key = "space f d";
      command = "workbench.action.quickOpen";
      when = "(editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput) || (!editorIsOpen && amVim.mode == 'NORMAL' && !amVim.waitingForInput)";
    }
    {
      key = "space f n";
      command = "workbench.action.files.newUntitledFile";
      when = "(editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput) || (!editorIsOpen && amVim.mode == 'NORMAL' && !amVim.waitingForInput)";
    }
    {
      key = "space f s";
      command = "workbench.action.files.save";
      when = "editorTextFocus && amVim.mode == 'NORMAL' && !amVim.waitingForInput";
    }
  ];
}
