{ config, pkgs, inputs, secrets, ... }:
let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.nixpkgs) config;
  };
in
{
  # make pkgsUnstable available to all modules
  _module.args.pkgsUnstable = pkgsUnstable;
  _module.args.secrets = secrets;
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
    ../../common/home/btca.nix
    ../../../modules/home/ipython.nix
    ../../../modules/home/vscode
    ../../../modules/home/mpv.nix
    ../../../modules/home/firefox
    ../../../modules/home/uv.nix
    ../../../modules/home/pushcli.nix
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
    "hazelnut/config.toml".source = ./config/hazelnut.toml;
  };
}
