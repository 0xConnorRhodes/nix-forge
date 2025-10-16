{ config, pkgs, inputs, ... }:

{
  imports = [
    ./markdown.nix
  ];

  programs.vscode.profiles.default.userSettings = {
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
