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
      configFile = {
        kcminputrc."Libinput/2/14/ETPS\\/2 Elantech Touchpad" = {
          "NaturalScroll" = true;
          "TapToClick" = false;
        };
      };
      shortcuts = {
        kwin = {
          "Window Close" = "Ctrl+Q";
        };
        "services/org.kde.krunner.desktop"."_launch" = "Ctrl+Space";
      };
      panels = [
        {
          location = "top";
          hiding = "autohide";
          widgets = [
            # We can configure the widgets by adding the name and config
            # attributes. For example to add the the kickoff widget and set the
            # icon to "nix-snowflake-white" use the below configuration. This will
            # add the "icon" key to the "General" group for the widget in
            # ~/.config/plasma-org.kde.plasma.desktop-appletsrc.
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
      #             "org.kde.plasma.battery"
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
