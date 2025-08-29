_: {
  programs.waybar = {
    enable = true;

    style = builtins.readFile ./waybar.css;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        output = [
          "DP-1"
          "DP-2"
          "*"
        ];

        modules-left = ["custom/notification" "clock" "tray"];
        modules-center = ["hyprland/workspaces"];
        modules-right = ["group/expand" "bluetooth" "network" "battery"];

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "";
            default = "";
            empty = "";
          };

          all-outputs = false;
        };

        "custom/notification" = {
          tooltip = false;
          format = "";
          on-click = "swaync-client -t -sw";
          escape = true;
        };

        "clock" = {
          format = "{:%H:%M}";
          interval = 60;
          tooltip = true;
          tooltip-format = "<tt>{calendar}</tt>";
          calendar.format.today = "<span color='#fAfBfC'><b>{}</b></span>";
          actions.on-click-right = "shift_down";
          actions.on-click = "shift_up";
        };

        "network" = {
          format-wifi = " ";
          format-ethernet = " ";
          format-disconnected = "";
          tooltip-format-disconnected = "Error";
          tooltip-format-wifi = "{essid} ({signalStrength}%)  ";
          tooltip-format-ethernet = "{ifname} 🖧";
          on-click = "foot nmtui";
        };

        "bluetooth" = {
          format-on = "󰂯";
          format-off = "BT-off";
          format-disabled = "󰂲";
          format-connected-battery = "{device_battery_percentage}% 󰂯";
          format-alt = "{device_alias} 󰂯";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\n{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\n{device_address}\n{device_battery_percentage}%";
          on-click-right = "blueman-manager";
        };
        "battery" = {
          interval = 30;
          states = {
            "good" = 85;
            "warning" = 30;
            "critical" = 20;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% 󰂄";
          format-plugged = "{capacity}% 󰂄 ";
          format-alt = "{time} {icon}";
          format-icons = [
            "󰁻"
            "󰁼"
            "󰁾"
            "󰂀"
            "󰂂"
            "󰁹"
          ];
        };

        "custom/expand" = {
          format = "";
          tooltip = false;
        };

        "custom/endpoint" = {
          format = "|";
          tooltip = false;
        };

        "group/expand" = {
          orientation = "horizontal";
          drawer = {
            transition-duration = 600;
            transition-to-left = true;
            click-to-reveal = true;
          };
          modules = ["custom/expand" "cpu" "memory" "temperature" "custom/endpoint"];
        };

        "hyprland/language" = {
          format = "{}";
          format-en = "us 🦅";
          format-da = "da 🇩🇰";
          on-click = "hyprctl switchxkblayout all next";
        };

        "cpu" = {
          format = "󰻠";
          tooltip = true;
        };

        "memory".format = "";

        "temperature" = {
          critical-threshold = 80;
          format = "";
        };

        "tray" = {
          icon-size = 14;
          spacing = 10;
        };

        "privacy" = {
          icon-spacing = 4;
          icon-size = 18;
          modules = [
            {
              type = "screenshare";
              tooltip = false;
            }
            {
              type = "audio-in";
              tooltip = false;
            }
          ];
        };
      };
    };
  };
}
