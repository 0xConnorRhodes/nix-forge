{
  myAliases = {

    # git
    gs = "git status --short";
    ga = "git add";
    gp = "git push";
    gu = "git pull";
    gl = "git log";
    gb = "git branch";
    gi = "git init";
    gcl = "git clone";
    gc = "git commit";

    # gc = "git checkout";
    gmm = "git add . && git commit -m 'u' && git rebase --continue && git push";

    e = "nvim";
    chx = "chmod +x";
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

    # connections
    mm = "mosh m";
    sm = "ssh m";
  };
}
