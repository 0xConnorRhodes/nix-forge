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

    profiles.default = {
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

        vim = {
          leader = "<Space";
          hlsearch = true;
          useSystemClipboard = true;
          foldfix = true; # don't unfold as you j/k through a folded heading
        };

        # extension settings
        extensions.autoCheckUpdates = false;

        # vscodevim.vim
        vim = {
          useCtrlKeys = true;
          useSystemClipboard = true;
        };

        # redhat.vscode-yaml
        redhat.telemetry.enabled = true; # YAML extension

        # sumneko.lua
        Lua = {
          window.statusBar = false;
        };

        # yzhang.markdown-all-in-one
        markdown.extension = {
          math.enabled = false;
        };

        # satokaz.vscode-markdown-header-coloring
        markdown-header-coloring = {
          backgroundColor = false;
        };

      };

      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        jnoortheen.nix-ide
        formulahendry.code-runner
        shopify.ruby-lsp
        redhat.vscode-yaml
        matthewpi.caddyfile-support
        tamasfe.even-better-toml
        sumneko.lua
        # ms-python.python
        # ms-python.vscode-pylance
        # ms-python.debugpy
        # ms-vscode.powershell
        # bmalehorn.vscode-fish
        # ms-vscode.live-server # live webapp in pane
        mechatroner.rainbow-csv
        ms-vscode-remote.remote-ssh
        yzhang.markdown-all-in-one # markdown bullets
      ] ++ (with marketplace-extensions; [
        # extensions outside of nixpkgs from nix-vscode extensions
        # pulls latest version without requirement of manual hash
        # format: user.extension-name (.downcase)
        satokaz.vscode-markdown-header-coloring
      ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "copilot";
          publisher = "GitHub";
          version = "1.323.0"; # works with code 1.100.1
          sha256 = "sha256-rTAq6snn3HAARrYbMJYy7aZ5rDucLfFS/t01VPjgXAo=";
        }
        {
          name = "copilot-chat";
          publisher = "GitHub";
          version = "0.27.2"; # works with code 1.100.1
          sha256 = "sha256-nwBDQNs5qrA0TxQZVtuXRiOy0iBNOCFpIim0x2k37YA=";
        }
      ]; 
    };
  };
}
