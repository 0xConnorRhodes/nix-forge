{ config, pkgs, ... }:

{
  imports = [
    ../../common/home/git.nix
    ../../common/home/bash.nix
    ../../common/home/zsh.nix
    ../../common/home/ripgrep.nix
    ../../common/home/zoxide.nix
    ../../common/home/starship.nix
    ../../common/home/bat.nix
    ../../common/home/lf.nix
    ../../common/home/wezterm.nix
    ../../common/home/vscode.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    # colon seperated list of dirs to be added to the default ruby $LOAD_PATH for importing modules
    RUBYLIB = "$HOME/code/ruby-modules/lib:$HOME/code/camdb/lib:$HOME/code/vapi/lib"; 
  };

  programs.zsh = {
    dirHashes= {
      dwn = "$HOME/Downloads";
      docs = "$HOME/Documents";
    };
    initContent = import ../../common/home/posixFunctions.nix;
  };


  programs.vscode.profiles.default = {
    userSettings = {
      # fonts: ideal size is 17 with zoom level 1
      editor.fontSize = 17;
      terminal.integrated.fontSize = 17;
      chat.editor.fontSize = 16;
      window.zoomLevel = 1;
    };
  };

  xdg.configFile = {
    "screen/screenrc".source = ../../common/home/config/screenrc;
  };
}
