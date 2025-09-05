{ config, pkgs, secrets, ... }:

let
  gitAliases = import ./git-aliases.nix;
in
{
  myAliases = gitAliases // {
    e = "nvim";
    chx = "chmod +x";
    xargs = "xargs -I __";
    j = "__zoxide_z";
    ji = "__zoxide_zi";
    cm = "chezmoi";
    cmd = "chezmoi cd";
    sn = "screen -c $HOME/.config/screen/screenrc";
    vm = "vimv";
    x = "exit";
    rb = "ruby";
    py = "python3";
    cat = "bat --style=plain";
    ipy = "ipython";
    cb = "ruby $HOME/code/food-log/add_entry.rb";
    reb = "$HOME/code/nix-forge/scripts/rebuild";
    lf = "lfcd";
    ari = "aria2c";
    bk = "buku";
    be = "bat --style=plain \"$(fzf)\"";
    dup = "docker compose up -d";

    # connections
    mm = "et -p 63104 m"; # "mosh m"
    sm = "ssh m";
  };
}
