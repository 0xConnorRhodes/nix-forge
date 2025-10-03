{ config, osConfig, pkgs, lib, ... }:

let
  # Get all .lua files in the current directory
  luaFiles = builtins.attrNames (lib.filterAttrs
    (name: type: type == "regular" && lib.hasSuffix ".lua" name)
    (builtins.readDir ./.));

  # Create home.file entries for each .lua file
  luaFileAttrs = lib.listToAttrs (map (filename: {
    name = ".config/wezterm/${filename}";
    value = {
      source = config.lib.file.mkOutOfStoreSymlink ./${filename};
    };
  }) luaFiles);
in
{
  home.file = luaFileAttrs;
}
