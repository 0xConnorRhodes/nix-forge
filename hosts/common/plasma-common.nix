{ config, lib, pkgs, ... }:

{
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.kdeconnect.enable = true;

  home-manager.users.${config.myConfig.username} = { pkgs, ... }: {
    home.stateVersion = "24.11";
    programs.plasma = {
      enable = true;
      kwin = {
        effects = {
          blur.enable = true;
        };
        titlebarButtons = {
          left = [ "close" "maximize" "minimize" ];
          right = [ ];
        };
      };
      workspace = {
        clickItemTo = "open";
        lookAndFeel = "org.kde.breezedark.desktop";
      };
      krunner = {
        activateWhenTypingOnDesktop = false;
        position = "center";
      };
      panels = [
        {
          location = "top";
          height = 34;
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
      ];
      configFile = {
        kcminputrc = {
          Keyboard = {
            "RepeatDelay" = 200;
            "RepeatRate" = 35;
          };
        };
        kwinrc = {
          Plugins = {
            screenedgeEnabled = false;
          };
        };
        kwinrulesrc = {
          "25bd0576-34dc-4506-ad48-8d34a6fe285e" ={
            "Description" = "Window settings for zen PiP";
            "title" = "Picture-in-Picture";
            "titlematch" = 1; # exact match
            "types" = 1; # window types: normal window

            "wmclass" = "zen";
            "wmclassmatch" = 1; # exact match

            "desktops" = "\\0"; # all desktops
            "desktopsrule" = 3; # apply initially

            "above" = true; # keep above other windows
            "aboverule" = 3; # apply initially

            "skipswitcher" = true;
            "skipswitcherrule" = 2; # force

            "acceptfocusrule" = 2; # force
          };

          "27207fbc-3dee-48fb-97b4-d6ba6d0f1428" = {
            "Description" = "Settings for zen main window";

            # show only on 1 desktop, default to desktop 1
            "desktops" = "2e63571e-1aa2-4dd3-a8e4-80d383761723";
            "desktopsrule" = 4;

            "wmclass" = "zen zen";
            "wmclassmatch" = 1; # exact match
            "wmclasscomplete" = true; # match whole window class

            "types" = 1; # normal window
          };
        };
        krunnerrc = {
          Plugins = {
            baloosearchEnabled = false;
            krunner_appstreamEnabled = false;
            krunner_katesessionsEnabled = false;
            krunner_konsoleprofilesEnabled = false;
            krunner_recentdocumentsEnabled = false;
            krunner_sessionsEnabled = false;
          };
        };
        plasmaparc = {
          General = {
            AudioFeedback = false; # disable chime on changing volume
          };
        };
      };
    };
  };
}
