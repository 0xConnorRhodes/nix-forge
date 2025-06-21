{ config, pkgs, inputs, ... }:
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
      # ms-vscode.powershell
      # ms-python.python
      # ms-python.vscode-pylance
      # ms-python.debugpy
      # bmalehorn.vscode-fish
      # ms-vscode.live-server # live webapp in pane
    ] ++

    # extensions from vscode marketplace (rolling)
    # from nix-vscode extensions
    # pulls latest version without requirement of manual hash
    # format: user.extension-name (.downcase)
    (with marketplace-extensions; [
      #satokaz.vscode-markdown-header-coloring
      sgtsquiggs.vscode-active-file-status # show open file in status bar
    ]) ++

    # pinned extensions pulled from vs code marketplace
    pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "copilot";
        publisher = "GitHub";
        version = "1.336.0";
        sha256 = "sha256-7IiYfOX3Xl3cW5FcG+7FjGAmkw7Wa9802eguRmaFE5Y=";
      }
      {
        name = "copilot-chat";
        publisher = "GitHub";
        version = "0.28.1";
        sha256 = "sha256-xOv1JYhE9Q8zRXoZVs/W1U58+SdbJwR5y354LLfKeDQ=";
      }
    ];
  };
}
