{
  flake.homeModules.hyprland-swaync =
    { lib, ... }:
    {
      services.swaync = {
        enable = true;

        style = lib.mkAfter (builtins.readFile ./style.css);

        settings = {
          positionX = "right";
          positionY = "top";
          layer = "overlay";
          control-center-layer = "top";
          layer-shell = true;
          cssPriority = "application";

          control-center-width = 380;
          control-center-height = 860;
          control-center-margin-top = 2;
          control-center-margin-bottom = 2;
          control-center-margin-right = 1;
          control-center-margin-left = 0;

          notification-window-width = 400;
          notification-icon-size = 60;
          notification-body-image-height = 180;
          notification-body-image-width = 180;
          notification-inline-replies = true;
          notification-2fa-action = true;

          timeout = 6;
          timeout-low = 3;
          timeout-critical = 10;

          fit-to-screen = false;
          keyboard-shortcuts = true;
          image-visibility = "when-available";
          transition-time = 200;
          hide-on-clear = false;
          hide-on-action = false;
          script-fail-notify = true;
          widgets = [
            "title"
            "dnd"
            "notifications"
            "mpris"
            "volume"
            "backlight"
            "buttons-grid"
          ];
          widget-config = {
            title = {
              text = "Notifications";
              clear-all-button = true;
              button-text = " 󰆴 ";
            };

            dnd = {
              text = "Do not disturb";
            };

            label = {
              max-lines = 1;
              text = " ";
            };

            mpris = {
              image-size = 96;
              image-radius = 12;
              show-album-art = "when-available";
              auto-hide = false;
            };

            volume = {
              label = "󰕾 ";
              show-per-app = false;
            };

            backlight.label = "󰃟 ";

            buttons-grid = {
              buttons-per-row = 3;
              actions = [
                # {
                #   "label" = "󰝟";
                #   "command" = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
                #   "type" = "toggle";
                # }
                # {
                #   "label" = "󰍭";
                #   "command" = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
                #   "type" = "toggle";
                # }
                {
                  "label" = " ";
                  "command" = "foot nmtui";
                }
                {
                  "label" = "";
                  "command" = "blueman-manager";
                }
                # {
                #   "label" = "󰈙";
                #   "command" = "kitty bash -i -c 'Docs'";
                # }
                # {
                #   "label" = "";
                #   "command" = "kitty bash -i -c 'Settings'";
                # }
                # {
                #   "label" = "";
                #   "command" = "kitty bash -i -c 'tasks'";
                # }
                {
                  "label" = "";
                  "command" = "hyprlock";
                }
                {
                  "label" = "";
                  "command" = "systemctl reboot";
                }
                {
                  "label" = "";
                  "command" = "systemctl poweroff";
                }
              ];
            };
          };
        };
      };
    };
}
