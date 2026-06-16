{
  flake.homeModules.noctalia =
    { inputs, ... }:
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia = {
        enable = true;

        settings = {
          theme = {
            mode = "dark";
            source = "builtin";
            builtin = "Gruvbox";
          };

          location = {
            auto_locate = false;
            address = "Denmark";
          };

          bar.order = [ "main" ];

          bar.main = {
            enabled = true;
            position = "top";

            auto_hide = true;
            reserve_space = false;

            capsule = true;
            widget_spacing = 8;
            font_weight = "regular";

            start = [
              "clock"
              "sysmon"
            ];
            center = [ "workspaces" ];
            end = [
              "media"
              "tray"
              "notifications"
              "battery"
              "volume"
              "brightness"
              "control-center"
              "session"
            ];
          };

          widget.workspaces = {
            display = "none";
            hide_when_empty = false;
          };

          dock.enabled = false;

          wallpaper = {
            enabled = true;
            directory = "~/Pictures/Wallpapers";
            recursiveSearch = true;
            setWallpaperOnAllMonitors = true;
            transitionDuration = 1000;
          };

          shell.session = {
            enabled = true;
            actions = [
              {
                action = "lock";
              }
              # {
              #   action = "suspend";
              # }
              # {
              #   action = "hibernate";
              # }
              {
                action = "reboot";
              }
              {
                action = "logout";
              }
              {
                action = "shutdown";
              }
            ];

            enableCountdown = true;
            countdownDuration = 5000;
          };
        };
      };
    };
}
