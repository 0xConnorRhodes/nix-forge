{ config, pkgs, inputs, ... }:

{
  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      ms-vscode.powershell
    ];
  };
}