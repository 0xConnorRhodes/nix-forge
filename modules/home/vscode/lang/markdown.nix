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

    github.copilot.enable.markdown = false;

    # EXTENSION SETTINGS

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

    # yzhang.markdown-all-in-one
    markdown.extension = {
      math.enabled = false;
    };
  };
}
