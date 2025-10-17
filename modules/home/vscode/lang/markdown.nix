{ config, pkgs, inputs, ... }:

{
  programs.vscode.profiles.default.userSettings = {
    "[markdown]" = {
      editor = {
        bracketPairColorization.enabled = false;
        lightbulb.enabled = "off";
        matchBrackets = false;
        guides = {
          bracketPairs = false;
          bracketPairsHorizontal = false;
        };
      };
    };

    # satokaz.vscode-markdown-header-coloring
    markdown-header-coloring = {
      backgroundColor = false;
      userDefinedHeaderColor = {
        enabled = true;

        Header_1 = { color = "#78DCE8"; };
        Header_2 = { color = "#82AAFF"; };
        Header_3 = { color = "#C792EA"; };
        Header_4 = { color = "#FFCB6B"; };
        Header_5 = { color = "#FF5370"; };
        Header_6 = { color = "#C3E88D"; };
      };
    };
  };
}
