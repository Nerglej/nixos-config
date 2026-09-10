{
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.wil.noctalia;
in
{
  options.wil.noctalia = {
    enable = mkEnableOption "noctalia";
  };

  config = mkIf cfg.enable {
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
          show_labels = false;
          hide_when_empty = false;
        };

        dock.enabled = false;

        wallpaper = {
          enabled = true;
          directory = "~/Pictures/Wallpapers";

          transition_on_startup = false;
          transition_duration = 1000;
          per_monitor_directories = false;

          automation.recursive = true;
        };

        shell.session = {
          enabled = true;
          actions = [
            {
              action = "lock";
              variant = "default";
            }
            # {
            #   action = "suspend";
            # }
            # {
            #   action = "hibernate";
            # }
            {
              action = "logout";
              variant = "default";
              countdown_seconds = 3;
            }
            {
              action = "reboot";
              variant = "default";
              countdown_seconds = 3;
            }
            {
              action = "shutdown";
              variant = "destructive";
              countdown_seconds = 5;
            }
          ];
        };

        shell.greeter_sync = {
          auto_sync = true;
        };
      };
    };
  };
}
