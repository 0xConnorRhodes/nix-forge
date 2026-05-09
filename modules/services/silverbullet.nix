{ config, pkgs, pkgsUnstable, lib, ... }:

let
  ignorePatterns = lib.concatStringsSep "\\n" [
    "skills"
    # "folder2"
  ];

  # this indirection is needed to ensure proper syntax in generated command
  # export SB_SPACE_IGNORE=$'folder1\nfolder2'
  silverbulletWithIgnore = pkgs.writeShellScriptBin "silverbullet" (
    "export SB_SPACE_IGNORE=$'" + ignorePatterns + "'\n"
    + "exec ${lib.getExe pkgs.silverbullet} \"$@\""
  );
in
{
  services.silverbullet = {
    enable = true;
    package = silverbulletWithIgnore;
    user = config.myConfig.username;
    group = "users";
    spaceDir = "${config.myConfig.homeDir}/code/notes";
    listenAddress = "127.0.0.1";
    listenPort = 38157;
  };
}

