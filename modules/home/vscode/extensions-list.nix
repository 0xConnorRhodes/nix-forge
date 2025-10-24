{ config, lib, pkgs, pkgsUnstable, inputs, ... }:
let
  nix-vscode-extensions = inputs.nix-vscode-extensions.extensions.${pkgs.system};
  marketplace-extensions = nix-vscode-extensions.vscode-marketplace;
in
{
  programs.vscode.profiles.default = {

    # extensions from nixpgks
    extensions = with pkgs.vscode-extensions; [
      # vscodevim.vim
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
      sgtsquiggs.vscode-active-file-status # show open file in status bar
      auiworks.amvim # better performance
      # google.geminicodeassist
      #github.copilot
      #github.copilot-chat
    ]) ++

    # pinned extensions pulled from vs code marketplace
    pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        # https://marketplace.visualstudio.com/items?itemName=GitHub.copilot
        # https://search.nixos.org/packages?show=vscode-extensions.github.copilot&query=vscode-extensions.github.copilot
        name = "copilot";
        publisher = "GitHub";
        version = "1.372.0";
        sha256 = "sha256-1L4zE2waIjI1Z8hYFaeHbnSWX9g31Sre4uDNOiQ2Fz8=";
      }
      {
        # https://github.com/microsoft/vscode-copilot-chat/releases
        # https://search.nixos.org/packages?show=vscode-extensions.github.copilot-chat&query=vscode-extensions.github.copilot-chat
        name = "copilot-chat";
        publisher = "GitHub";
        version = "0.31.5";
        sha256 = "sha256-D7k+hA786w7IZHVI+Og6vHGAAohpfpuOmmCcDUU0WsY=";
      }
    ];
  };
}
