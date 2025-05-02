{ config, pkgs, ... }:

{
  imports = [
    ../../common/home/git.nix
    ../../common/home/bash.nix
    ../../common/home/zsh.nix
    ../../common/home/ripgrep.nix
    ../../common/home/zoxide.nix
    ../../common/home/starship.nix
    ../../common/home/ghostty.nix
    ../../common/home/vscode.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.zsh = {
    dirHashes= {
      dwn = "$HOME/Downloads";
      docs = "$HOME/Documents";
    };
    initExtra = ''
      nf() {
        ls -At1 . | sed '/\.git/d' | sed -n '1p'
      }

      lnf() {
        ls -At1 . | sed '/\.git/d' | sed -n '2p'
      }
    '';
  };


  programs.ghostty.settings = {
    font-size = 17;
  };

  programs.vscode = {
    userSettings = {
      editor.fontSize = 17;
      terminal.integrated.fontSize = 17;
      chat.editor.fontSize = 16;
    };
  };

  xdg.configFile = {
    "screen/screenrc".source = ../../common/home/config/screenrc;
  };
}
