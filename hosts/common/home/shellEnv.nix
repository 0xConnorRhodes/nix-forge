{ lib, pkgs, osConfig, secrets, allPaths }:
let
  pythonPaths = [
    "$CODE/vikunja-dev/module"
    "$CODE/camdb/module"
    "$CODE/serial_gemini_web/module"
    "$CODE/audiobookshelf_client/module"
  ];
  paths = ''
    export PATH="${lib.concatStringsSep ":" allPaths}:$PATH"
    export PYTHONPATH="${lib.concatStringsSep ":" pythonPaths}"
  '';

  configDirs = ''
    export IPYTHONDIR="${osConfig.myConfig.homeDir}/.config/ipython"
    export SYSTEMD_PAGER=cat
  '';

  apiKeys = ''
    export API_SERVER_KEY=${secrets.apiServerKey}
  '';
in
  paths + configDirs + apiKeys
