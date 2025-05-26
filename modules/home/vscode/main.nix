{ config, pkgs, inputs, ... }:
let

  myZshProfile = {
    path = "zsh";
    args = [
      "-l"
    ];
  };
in 
{
  imports = [
    ./keybindings.nix
    ./extensions-list.nix
    ./extensions-settings.nix
  ];

  nixpkgs.config.allowUnfree = true;
  programs.vscode = {
    enable = true;

    profiles.default = {
      enableUpdateCheck = false;
      userSettings = {
        workbench.startupEditor = "none"; # don't show startup screen
        update.mode = "none";
        files.autoSave = "afterDelay";
        editor.fontFamily = "'JetBrainsMono Nerd Font', 'monospace', monospace";
        editor = {
          tabSize = 2;
          minimap.enabled = false;
          formatOnSave = true;
          defaultFormatter = "null";
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
      };

      #extensions = with pkgs.vscode-extensions; [
      # ] ++ (with marketplace-extensions; [
      #   # extensions outside of nixpkgs from nix-vscode extensions
      #   # pulls latest version without requirement of manual hash
      #   # format: user.extension-name (.downcase)
      #   satokaz.vscode-markdown-header-coloring
      # ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      #   {
      #     name = "copilot";
      #     publisher = "GitHub";
      #     version = "1.323.0"; # works with code 1.100.1
      #     sha256 = "sha256-rTAq6snn3HAARrYbMJYy7aZ5rDucLfFS/t01VPjgXAo=";
      #   }
      #   {
      #     name = "copilot-chat";
      #     publisher = "GitHub";
      #     version = "0.27.2"; # works with code 1.100.1
      #     sha256 = "sha256-nwBDQNs5qrA0TxQZVtuXRiOy0iBNOCFpIim0x2k37YA=";
      #   }
      # ]; 
    };
  };
}
