{ config, lib, pkgs, pkgsUnstable, inputs, ... }:
let
  nix-vscode-extensions = inputs.nix-vscode-extensions.extensions.${pkgs.system};
  marketplace-extensions = nix-vscode-extensions.vscode-marketplace;
in
{
  programs.vscode.profiles.default = {

    # extensions from nixpgks
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      jnoortheen.nix-ide
      formulahendry.code-runner
      shopify.ruby-lsp
      redhat.vscode-yaml
      matthewpi.caddyfile-support
      tamasfe.even-better-toml
      sumneko.lua
      jgclark.vscode-todo-highlight # highlight todo and fixme, maintained version
      mechatroner.rainbow-csv
      ms-vscode-remote.remote-ssh
      yzhang.markdown-all-in-one # markdown bullets
      ms-python.python
      ms-python.vscode-pylance
      ms-python.debugpy
      # ms-vscode.powershell
      # bmalehorn.vscode-fish
      # ms-vscode.live-server # live webapp in pane
      sdras.night-owl # theme
      # oderwat.indent-rainbow
    ] ++

    (with pkgsUnstable.vscode-extensions; [
      # github.copilot
      # github.copilot-chat
    ]) ++

    # extensions from vscode marketplace (rolling)
    # from nix-vscode extensions
    # pulls latest version without requirement of manual hash
    # format: user.extension-name (.downcase)
    (with marketplace-extensions; [
      #satokaz.vscode-markdown-header-coloring
      sgtsquiggs.vscode-active-file-status # show open file in status bar
      # google.geminicodeassist
      # github.copilot
      # github.copilot-chat
    ]) ++

    # pinned extensions pulled from vs code marketplace
    pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        # https://marketplace.visualstudio.com/items?itemName=GitHub.copilot
        # https://search.nixos.org/packages?show=vscode-extensions.github.copilot&query=vscode-extensions.github.copilot
        name = "copilot";
        publisher = "GitHub";
        version = "1.364.0";
        sha256 = "sha256-5nDbGhqvdU4Ivmat0DevkXN8d8JN3Z+0bptqNqbWIR8=";
      }
      {
        # https://github.com/microsoft/vscode-copilot-chat/releases
        # https://search.nixos.org/packages?show=vscode-extensions.github.copilot-chat&query=vscode-extensions.github.copilot-chat
        name = "copilot-chat";
        publisher = "GitHub";
        version = "0.29.1";
        sha256 = "sha256-v9PP+3psOOMCrIgIaVqrwOUZ9tqTXiSjUUuOcCrEie4=";
      }
    ];
  };
}
