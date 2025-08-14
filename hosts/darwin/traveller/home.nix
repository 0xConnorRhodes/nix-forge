{ config, pkgs, inputs, secrets, osConfig, ... }:

{
  imports = [
    ./packages.nix
    ./comma.nix
    ./home-secret.nix
    ../../common/home/git.nix
    ../../common/home/bash.nix
    ../../common/home/zsh.nix
    ../../common/home/ripgrep.nix
    ../../common/home/zoxide.nix
    ../../common/home/starship.nix
    ../../common/home/bat.nix
    ../../common/home/lf.nix
    ../../../pkgs/cursedtag.nix
    ../../../configs/wezterm/wezterm-common.nix
    ../../../modules/home/vscode
    ../../../modules/home/firefox
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    CODE = "${osConfig.myConfig.homeDir}/code";
    NOTES = "$CODE/notes";
    # colon seperated list of dirs to be added to the default ruby $LOAD_PATH for importing modules
    RUBYLIB = "$HOME/code/ruby-modules/lib:$HOME/code/camdb/lib:$HOME/code/vapi/lib";
  };

  programs.zsh.shellAliases = {
    yo = "open -a yoink";
  };

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.vscode.profiles.default = {
    userSettings = {
      editor.fontSize = 14; # 19 with zoom 0
      terminal.integrated.fontSize = 14; # 20 with no zoom
      chat.editor.fontSize = 13;
      window.zoomLevel = 2;
    };
  };

  programs.zsh = {
    dirHashes= {
      dwn = "$HOME/Downloads";
      docs = "$HOME/Documents";
    };
    initContent = import ../../common/home/posixFunctions.nix;
  };

  xdg.configFile = {
    # "skhd/skhdrc".source = ./config/skhdrc;
    "ghostty/config".source = ./config/ghostty;
    "screen/screenrc".source = ../../common/home/config/screenrc;
  };

  # Don't show the "Last login" message for every new terminal.
  home.file.".hushlogin" = { text = ""; };
}
