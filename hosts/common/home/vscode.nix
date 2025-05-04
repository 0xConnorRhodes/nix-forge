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
    package = pkgs.vscode;
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

    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      jnoortheen.nix-ide
      formulahendry.code-runner
      shopify.ruby-lsp
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "copilot";
      publisher = "GitHub";
      version = "1.312.0"; # works with code 1.99.3
      sha256 = "sha256-CsOOE/Lpfv1JL9h3KaHfGXIDZcF9KuWo4qIwzwFT1Gk=";
    }
    {
      name = "copilot-chat";
      publisher = "GitHub";
      version = "0.26.7"; # works with code 1.99.3
      sha256 = "sha256-aR6AGU/boDmYef0GWna5sUsyv9KYGCkugWpFIusDMNE=";
    } ]
    ++ (with marketplace-extensions; [
      # extions outside of nixpkgs
      # user.extension-name
      sumneko.lua
    ]); 
  };
}
