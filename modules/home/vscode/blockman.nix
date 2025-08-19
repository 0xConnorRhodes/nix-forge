{ config, lib, pkgs, inputs, ... }:
let
  nix-vscode-extensions = inputs.nix-vscode-extensions.extensions.${pkgs.system};
  marketplace-extensions = nix-vscode-extensions.vscode-marketplace;
in
{
  programs.vscode.profiles.default = {
    # Blockman extension from marketplace
    extensions = with marketplace-extensions; [
      leodevbro.blockman
    ];

    # Blockman recommended settings
    userSettings = {
      editor = {
        inlayHints.enabled = "off";
        guides.indentation = lib.mkForce false;
        guides.bracketPairs = lib.mkForce false;
        wordWrap = "off";
      };
      diffEditor.wordWrap = "off";

      workbench.colorCustomizations = {
        editor.lineHighlightBorder = "#9fced11f";
        editor.lineHighlightBackground = "#1073cf2d";
      };
    };
  };
}
