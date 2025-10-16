{ config, pkgs, inputs, ... }:

{
  programs.vscode.profiles.default.userSettings = {
    "[markdown]" = {
      editor = {
        bracketPairColorization.enabled = false;
        lightbulb.enabled = "off";
        guides = {
          bracketPairs = false;
          bracketPairsHorizontal = false;
        };
      };
    };

    "[python]" = {
      editor = {
        tabSize = 4;
        renderWhitespace = "boundary";
        guides = {
          indentation = true;
          bracketPairs = false;
          bracketPairsHorizontal = false;
        };
      };
    };

    "[yaml]" = {
      editor.guides.indentation = false;
      editor.guides.bracketPairs = false;
      editor.guides.bracketPairsHorizontal = false;
    };
  };
}
