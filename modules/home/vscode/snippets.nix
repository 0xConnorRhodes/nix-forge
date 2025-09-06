{ config, ... }:

{
  programs.vscode.profiles.default = {
    languageSnippets = {
      nix = {
        cronpython = {
          body = [
            "{ config, lib, pkgs, ... }:"
            "let"
            "  user = config.myConfig.username;"
            "  workingDir = \"\${config.myConfig.homeDir}/code/\${1:project-folder}\";"
            "  cronPython = pkgs.python3.withPackages (ps: with ps; ["
            "    \${2:some-python-package}"
            "  ]);"
            "in"
            "{"
            "  # \${3:A brief description of the job}"
            ""
            "  # The systemd timer definition"
            "  systemd.timers.\"\${4:job-name}\" = {"
            "    wantedBy = [ \"timers.target\" ];"
            "    timerConfig = {"
            "      OnCalendar = \"\${5:daily}\"; # Examples: daily, weekly, hourly, *-*-* 03:00:00"
            "      Persistent = true; # Run missed jobs on next boot"
            "      Unit = \"\${4:job-name}.service\";"
            "    };"
            "  };"
            ""
            "  # The systemd service that the timer triggers"
            "  systemd.services.\"\${4:job-name}\" = {"
            "    script = ''"
            "      set -eu"
            "      \${cronPython}/bin/python3 \${workingDir}\${6:main.py}"
            "    '';"
            "    serviceConfig = {"
            "      Type = \"oneshot\";"
            "      User = user;"
            "      WorkingDirectory = workingDir;"
            "    };"
            "  };"
            "}"
          ];
          description = "cronpython snippet";
          prefix = [
            "cronpy"
          ];
        };
      };
    };
  };
}
