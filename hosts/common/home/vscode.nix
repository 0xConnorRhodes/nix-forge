{ config, pkgs, inputs, ... }:
let
  nix-vscode-extensions = inputs.nix-vscode-extensions.extensions.${pkgs.system};
  marketplace-extensions = nix-vscode-extensions.vscode-marketplace;

  myZshProfile = {
    path = "zsh";
    args = [
      "-l"
    ];
  };
in 
{
  nixpkgs.config.allowUnfree = true;
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    userSettings = {
      files.autoSave = "afterDelay";
      editor = {
        tabSize = 2;
      };
      explorer = {
        confirmDragAndDrop = false;
        confirmDelete = false;
      };
      github.copilot.enable."*" = false;

      terminal.integrated.profiles.osx = {
        myZsh = myZshProfile;
      };

      terminal.integrated.defaultProfile = {
        linux = "myZsh";
        osx = "myZsh";
      };
    };

    extensions =
      with pkgs.vscode-extensions; [
        vscodevim.vim
        formulahendry.code-runner
        jnoortheen.nix-ide
        shopify.ruby-lsp
      ]
      ++ (with marketplace-extensions; [
        # item 1
      ]); 
  };
}