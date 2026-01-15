{
  myAliases = {

    # git (see also posixFunctions)
    gs = "git status";
    gp = "git push";
    gu = "git pull";
    gl = "git log";
    gb = "git branch";
    gi = "git init";
    gcl = "git clone";
    gc = "git commit";
    gco = "git checkout";
    gmm = "git add . && git commit -m 'u' && git rebase --continue && git push";

    sudo = "sudo "; # ensures commands after sudo are also checked for aliases
    systemctl = "systemctl --no-pager";
    cl = "clear";

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
    cat = "bat --style=plain --no-pager --theme=base16"; # theme needed for gnu screen compatibility
    ipy = "ipython";
    lf = "lfcd";
    ari = "aria2c";
    bk = "buku";
    be = "bat --style=plain --theme=base16 \"$(fzf)\"";
    dup = "docker compose up -d";
    sl = "systemctl";
    ssl = "sudo systemctl";
    cht = "cht.sh";
    fn = "fnox";
    sc = "sc-im";
    js = "just";
    sb = "silverbullet $HOME/notes";

    # notifications for woof
    nt="export NOTIFICATIONS=true && echo 'notifications on'";
    ntof="export NOTIFICATIONS=false && echo 'notifications off'";

    # connections
    mm = "et -p 63104 m"; # "mosh m"
    sm = "ssh m";

    # scripts
    reb = "$HOME/code/nix-forge/scripts/rebuild";
  };
}
