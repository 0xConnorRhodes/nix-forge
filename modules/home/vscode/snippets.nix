{ config, ... }:

{
  programs.vscode.profiles.default = {
    languageSnippets = {
      nix = {
        module = {
          description = "basic nixos module import";
          body = [
            "{ config, pkgs, ... }:"
            ""
            "{"
            "  \${1:code}"
            "}"
          ];
          prefix = [
            "nixmodule"
          ];
        };
        systemdTimerAndService = {
          description = "Creates a NixOS systemd timer and a corresponding one-shot service.";
          body = [
            "systemd.timers.\"\${1:service-name}\" = {"
            "  wantedBy = [ \"timers.target\" ];"
            "  timerConfig = {"
            "    OnCalendar = \"\${2:daily}\"; # Examples: daily, weekly, hourly, *-*-* 03:00:00"
            "    Persistent = true; # Run missed jobs on next boot"
            "    Unit = \"\${1:service-name}.service\";"
            "  };"
            "};"
            ""
            "systemd.services.\"\${1:service-name}\" = {"
            "  path = with pkgs; ["
            "    \${3:Script Dependencies}"
            "  ];"
            "  script = ''"
            "    set -eu"
            "    \${4:Hello World}"
            "  '';"
            "  serviceConfig = {"
            "    Type = \"oneshot\";"
            "    User = \"\${config.myConfig.username}\";"
            "  };"
            "};"
          ];
          prefix = [
            "cronjob"
            "systemd-timer"
          ];
        };

        cronpython = {
          description = "cronpython snippet";
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
          prefix = [
            "cronpy"
          ];
        };
      };
    };
  };
}
