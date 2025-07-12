{ config, lib, pkgs, ... }:

{
  imports = [
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
        kcminputrc = {
          "Libinput/2/14/ETPS\\/2 Elantech Touchpad" = {
            # configure touchpad for 2 finger right click instead of zone based left|middle|right click
            "Enabled" = true;
            "NaturalScroll" = true;
            "TapToClick" = false;
            "ClickMethod" = 2;
            "Tapping" = true;
          };

          "Libinput/2/14/ETPS\\/2 Elantech TrackPoint" = {
            "Enabled" = true;
            "PointerAcceleration" = 0.400;
          };
        };
        kscreenlockerrc.Daemon.Timeout = 15; # minutes until screen locks automatically
      };
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
          "increase_volume" = "F3";
          "increase_volume_small" = "Meta+Shift+F3";
          "decrease_volume" = "F2";
          "decrease_volume_small" = "Meta+Shift+F2";
          "mute" = "F4";
          "mic_mute" = "Meta+Shift+F4";
        };
        org_kde_powerdevil = {
          "Decrease Screen Brightness" = "F5";
          "Increase Screen Brightness" = "F6";

          "Increase Screen Brightness Small" = "Meta+Shift+F6";
          "Decrease Screen Brightness Small" = "Meta+Shift+F5";
        };
      };
      fonts = {
        general = {
          family = "Noto Sans";
          pointSize = 12;
        };
        windowTitle = {
          family = "Noto Sans";
          pointSize = 12;
        };
      };
      powerdevil = {
        battery = {
          dimDisplay = {
            enable = true;
            idleTimeout = 600; # 10m
          };
          turnOffDisplay = {
            idleTimeout = 900; # 15m as well, dim display then sleep, don't turn off display as an intermediate step
            idleTimeoutWhenLocked = 60; # 1m
          };
          autoSuspend = {
            action = "sleep";
            idleTimeout = 900; # 15m
          };
          inhibitLidActionWhenExternalMonitorConnected = true;
          powerButtonAction = "sleep";
          whenLaptopLidClosed = "sleep";
        };
        AC = {
          dimDisplay.enable = false;
          autoSuspend = {
            action = "sleep";
            idleTimeout = 1200; # 20m
          };
          inhibitLidActionWhenExternalMonitorConnected = true;
          powerButtonAction = "lockScreen";
          whenLaptopLidClosed = "sleep";
        };
      };
      panels = [
        {
          location = "top";
          hiding = "autohide";
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
      #   # Windows-like panel at the bottom
      #   {
      #     widgets = [
      #       # We can configure the widgets by adding the name and config
      #       # attributes. For example to add the the kickoff widget and set the
      #       # icon to "nix-snowflake-white" use the below configuration. This will
      #       # add the "icon" key to the "General" group for the widget in
      #       # ~/.config/plasma-org.kde.plasma.desktop-appletsrc.
      #       {
      #         name = "org.kde.plasma.kickoff";
      #         config = {
      #           General = {
      #             icon = "nix-snowflake-white";
      #             alphaSort = true;
      #           };
      #         };
      #       }
      #       # Or you can configure the widgets by adding the widget-specific options for it.
      #       # See modules/widgets for supported widgets and options for these widgets.
      #       # For example:
      #       {
      #         kickoff = {
      #           sortAlphabetically = true;
      #           icon = "nix-snowflake-white";
      #         };
      #       }
      #       # Adding configuration to the widgets can also for example be used to
      #       # pin apps to the task-manager, which this example illustrates by
      #       # pinning dolphin and konsole to the task-manager by default with widget-specific options.
      #       {
      #         iconTasks = {
      #           launchers = [
      #             "applications:org.kde.dolphin.desktop"
      #             "applications:org.kde.konsole.desktop"
      #           ];
      #         };
      #       }
      #       # Or you can do it manually, for example:
      #       {
      #         name = "org.kde.plasma.icontasks";
      #         config = {
      #           General = {
      #             launchers = [
      #               "applications:org.kde.dolphin.desktop"
      #               "applications:org.kde.konsole.desktop"
      #             ];
      #           };
      #         };
      #       }
      #       # If no configuration is needed, specifying only the name of the
      #       # widget will add them with the default configuration.
      #       "org.kde.plasma.marginsseparator"
      #       # If you need configuration for your widget, instead of specifying the
      #       # the keys and values directly using the config attribute as shown
      #       # above, plasma-manager also provides some higher-level interfaces for
      #       # configuring the widgets. See modules/widgets for supported widgets
      #       # and options for these widgets. The widgets below shows two examples
      #       # of usage, one where we add a digital clock, setting 12h time and
      #       # first day of the week to Sunday and another adding a systray with
      #       # some modifications in which entries to show.
      #       {
      #         digitalClock = {
      #           calendar.firstDayOfWeek = "sunday";
      #           time.format = "12h";
      #         };
      #       }
      #       {
      #         systemTray.items = {
      #           # We explicitly show bluetooth and battery
      #           shown = [
      #             "org.kde.plasma.battery"org.kde.plasma.panelspacer""
      #             "org.kde.plasma.bluetooth"
      #           ];
      #           # And explicitly hide networkmanagement and volume
      #           hidden = [
      #             "org.kde.plasma.networkmanagement"
      #             "org.kde.plasma.volume"
      #           ];
      #         };
      #       }
      #     ];
      #   }
      #   # Application name, Global menu and Song information and playback controls at the top
      #   {
      #     location = "top";
      #     height = 26;
      #     widgets = [
      #       {
      #         applicationTitleBar = {
      #           behavior = {
      #             activeTaskSource = "activeTask";
      #           };
      #           layout = {
      #             elements = [ "windowTitle" ];
      #             horizontalAlignment = "left";
      #             showDisabledElements = "deactivated";
      #             verticalAlignment = "center";
      #           };
      #           overrideForMaximized.enable = false;
      #           titleReplacements = [
      #             {
      #               type = "regexp";
      #               originalTitle = "^Brave Web Browser$";
      #               newTitle = "Brave";
      #             }
      #             {
      #               type = "regexp";
      #               originalTitle = ''\\bDolphin\\b'';
      #               newTitle = "File manager";
      #             }
      #           ];
      #           windowTitle = {
      #             font = {
      #               bold = false;
      #               fit = "fixedSize";
      #               size = 12;
      #             };
      #             hideEmptyTitle = true;
      #             margins = {
      #               bottom = 0;
      #               left = 10;
      #               right = 5;
      #               top = 0;
      #             };
      #             source = "appName";
      #           };
      #         };
      #       }
      #       "org.kde.plasma.appmenu"
      #       "org.kde.plasma.panelspacer"
      #       {
      #         plasmusicToolbar = {
      #           panelIcon = {
      #             albumCover = {
      #               useAsIcon = false;
      #               radius = 8;
      #             };
      #             icon = "view-media-track";
      #           };
      #           playbackSource = "auto";
      #           musicControls.showPlaybackControls = true;
      #           songText = {
      #             displayInSeparateLines = true;
      #             maximumWidth = 640;
      #             scrolling = {
      #               behavior = "alwaysScroll";
      #               speed = 3;
      #             };
      #           };
      #         };
      #       }
      #     ];
      #   }
      ];
    };
  };
}
