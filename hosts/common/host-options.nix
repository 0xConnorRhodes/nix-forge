{ config, lib, ... }:

{
  options = {
    myConfig = {
      username = lib.mkOption { type = lib.types.str; default = "connor";};
      homeDir = lib.mkOption { type = lib.types.str; default = "/home/connor";};
      trashcli = lib.mkOption { type = lib.types.str; default = "trash";}; # built in to macOS
      modAlt = lib.mkOption { type = lib.types.str; default = "alt"; }; # modkey on the physical Alt key on a conventional keyboard
      modCtrl = lib.mkOption { type = lib.types.str; default = "ctrl"; }; # modkey on the physical Alt key on a conventional keyboard
      hostPaths = lib.mkOption { type = lib.types.listOf lib.types.str; default = []; };
    };
  };
}
