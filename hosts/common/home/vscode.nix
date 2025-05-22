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
      editor.fontFamily = "'JetBrainsMono Nerd Font', 'monospace', monospace";
      editor = {
        tabSize = 2;
      };
      explorer = {
        confirmDragAndDrop = false;
        confirmDelete = false;
      };
      github.copilot.enable."*" = false;
      git.openRepositoryInParentFolders = "never";

      terminal.integrated.profiles.osx = {
        myZsh = myZshProfile;
      };

      terminal.integrated.defaultProfile = {
        linux = "myZsh";
        osx = "myZsh";
      };

      redhat.telemetry.enabled = true; # YAML extension
    };

    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      jnoortheen.nix-ide
      formulahendry.code-runner
      shopify.ruby-lsp
      redhat.vscode-yaml
      matthewpi.caddyfile-support
      tamasfe.even-better-toml
      # sumneko.lua
      # ms-python.python
      # ms-python.vscode-pylance
      # ms-python.debugpy
      # ms-vscode.powershell
      # bmalehorn.vscode-fish
      # ms-vscode.live-server # live webapp in pane
      mechatroner.rainbow-csv
      ms-vscode-remote.remote-ssh
    ] ++ (with marketplace-extensions; [
      # extensions outside of nixpkgs from nix-vscode extensions
      # pulls latest version without requirement of manual hash
      # format: user.extension-name
    ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
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
      }
    ]; 
  };
}
