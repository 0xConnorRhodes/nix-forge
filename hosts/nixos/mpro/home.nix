{ config, pkgs, ... }:

{
  imports = [
    ../../common/home/git.nix
    ../../common/home/zsh.nix
    ../../common/home/ripgrep.nix
    ../../common/home/zoxide.nix
    ../../common/home/vscode.nix
  ];

  xdg.configFile = {
    "ghostty/config".source = ./config/ghostty;
    "screen/screenrc".source = ../../common/home/config/screenrc;
  };
}
