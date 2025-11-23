{ inputs, config, ... }:

# IPYTHONDIR is set to ~/.config in zsh.nix

{
  home.file.".config/ipython/profile_default/ipython_config.py".text = ''
    c = get_config()  #noqa
    c.TerminalInteractiveShell.confirm_exit = False
    c.TerminalInteractiveShell.colors = 'Neutral'
  '';
}
