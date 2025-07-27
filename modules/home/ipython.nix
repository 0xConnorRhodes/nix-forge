{ inputs, config, ... }:

{
  home.file.".ipython/profile_default/ipython_config.py".text = ''
    c = get_config()  #noqa
    c.TerminalInteractiveShell.confirm_exit = False
  '';
}
