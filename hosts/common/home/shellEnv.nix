{ lib, pkgs, osConfig, secrets, allPaths }:
let
  paths = ''
    export PATH="${lib.concatStringsSep ":" allPaths}:$PATH"
    export PYTHONPATH="$CODE/vikunja-dev/module"
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
