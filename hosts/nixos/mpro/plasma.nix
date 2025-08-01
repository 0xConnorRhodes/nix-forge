{ config, lib, pkgs, ... }:

{
  imports = [
    ./konsole.nix
    ../../common/plasma-common.nix
  ];

  hardware.bluetooth.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.bluedevil
  ];

  home-manager.users.${config.myConfig.username} = { pkgs, ... }: {
    home.stateVersion = "24.11";
    programs.plasma = {
      krunner = {
        shortcuts.launch = "Ctrl+Space";
      };
      configFile = {
        kscreenlockerrc.Daemon.Timeout = 0; # no auto-locking

        # show date beside time in digitalclock widget in panel
        "plasma-org.kde.plasma.digitalclock.cfg" = {
          General = {
            showDate = "beside";
          };
        };
      };
      panels = [
        {
          location = "top";
          height = 24;
          hiding = "dodgewindows";
          widgets = [
            {
              name = "org.kde.plasma.kickoff";
              config = {
                General = {
                  icon = "nix-snowflake-white";
                  alphaSort = true;
                };
              };
            }
            "org.kde.plasma.icontasks"
            # {
            #   iconTasks = {
            #     # to get these names, check `ls /run/current-system/sw/share/applications` and `ls ~/.nix-profile/share/applications` and remove ".desktop" to get application names
            #     launchers = [
            #       "applications:org.wezfurlong.wezterm"
            #       "applications:zen"
            #       "applications:obsidian"
            #       "applications:code"
            #     ];
            #   };
            # }
            "org.kde.plasma.panelspacer"
            {
              systemTray.items = {
                shown = [
                  "org.kde.plasma.battery"
                  "org.kde.plasma.bluetooth"
                  "org.kde.plasma.networkmanagement"
                  "org.kde.plasma.volume"
                ];
                hidden = [
                  # "org.kde.plasma.networkmanagement"
                  # "org.kde.plasma.volume"
                ];
              };
            }
            {
              digitalClock = {
                calendar.firstDayOfWeek = "sunday";
                time.format = "12h";
              };
            }
          ];
        }
      ];
      shortcuts = {
        kwin = {
          "Overview" = "F1";
          "Window Maximize" = "Ctrl+Alt+I";
          "Window Minimize" = "Ctrl+H";
          "Window Close" = "Ctrl+Q";
          "Walk Through Windows" = "Ctrl+Tab";
          "Walk Through Windows (Reverse)" = "Ctrl+Shift+Tab";
          "Walk Through Windows of Current Application" = "Ctrl+`";
          "Walk Through Windows of Current Application (Reverse)" = "Ctrl+~";
          "Window Quick Tile Top" = "Ctrl+Alt+K";
          "Window Quick Tile Bottom" = "Ctrl+Alt+J";
          "Window Quick Tile Left" = "Ctrl+Alt+H";
          "Window Quick Tile Right" = "Ctrl+Alt+L";
        };
        kmix = {
          "increase_volume" = "Meta+F11";
          "increase_volume_small" = "Meta+Shift+F11";
          "decrease_volume" = "Meta+F10";
          "decrease_volume_small" = "Meta+Shift+F10";
          "mute" = "Meta+F9";
          "mic_mute" = "Meta+Shift+F9";
        };
      };
      fonts = {
        general = {
          family = "Noto Sans";
          pointSize = 10;
        };
        windowTitle = {
          family = "Noto Sans";
          pointSize = 10;
        };
      };
      powerdevil = {
      #   battery = {
      #     dimDisplay = {
      #       enable = true;
      #       idleTimeout = 600; # 10m
      #     };
      #     turnOffDisplay = {
      #       idleTimeout = 900; # 15m as well, dim display then sleep, don't turn off display as an intermediate step
      #       idleTimeoutWhenLocked = 60; # 1m
      #     };
      #     autoSuspend = {
      #       action = "sleep";
      #       idleTimeout = 900; # 15m
      #     };
      #     inhibitLidActionWhenExternalMonitorConnected = true;
      #     powerButtonAction = "sleep";
      #     whenLaptopLidClosed = "sleep";
      #   };
        AC = {
          dimDisplay = {
            enable = true;
            idleTimeout = 600; # 10m
          };
          turnOffDisplay = {
            idleTimeout = 1800; # 30m
            idleTimeoutWhenLocked = 60; # 1m
          };
          autoSuspend = {
            action = "nothing";
          };
          powerButtonAction = "nothing";
        };
      };
    };
  };
}
