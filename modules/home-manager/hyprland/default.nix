{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    settings = {
      "$mod" = "SUPER";

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

      bind =
        [
          # Current window actions
          "$mod, Q, killactive"
          "$mod, F, fullscreen"
          "$mod, G, togglefloating"

          # Move focus
          "$mod, H, movefocus, l"
          "$mod, J, movefocus, d"
          "$mod, K, movefocus, u"
          "$mod, L, movefocus, r"

          # Swap windows
          "$mod CTRL, H, swapwindow, l"
          "$mod CTRL, J, swapwindow, d"
          "$mod CTRL, K, swapwindow, u"
          "$mod CTRL, L, swapwindow, r"

          # Move windows
          "$mod SHIFT, H, movewindow, l"
          "$mod SHIFT, J, movewindow, d"
          "$mod SHIFT, K, movewindow, u"
          "$mod SHIFT, L, movewindow, r"

          # Some app shortcuts
          "$mod, T, exec, foot"
          "$mod ALT, F, exec, firefox"

          # Locale changes
          "$mod, M, exec, hyprctl switchxkblayout all next"
          "$mod, SPACE, exec, bemenu-run -c -p \"Open\" -l 10 -W 0.2"

          # Screenshot
          ''$mod SHIFT, S, exec, REGION=$(slurp) IMG_PATH=~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png || exit; grim -g "$REGION" - | wl-copy &&  wl-paste > "$IMG_PATH" && notify-send -i "$IMG_PATH" -t 1500 -a "Screenshot utility" "Screenshot" "Partial screenshot taken" ''
          ''$mod CTRL SHIFT, S, exec, IMG_PATH=~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png || grim - | wl-copy && wl-paste > "$IMG_PATH" && notify-send -i "$IMG_PATH" -t 1500 -a "Screenshot utility" "Screenshot" "Fullscreen screenshot taken" ''

          # Powermenu
          "$mod SHIFT, P, exec, bemenu_powermenu"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..5} to [move to] workspace
          # {1..5} on the corresponding monitor
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mod, code:1${toString i}, split-workspace, ${toString ws}"
                "$mod CTRL, code:1${toString i}, split-movetoworkspacesilent, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, split-movetoworkspace, ${toString ws}"
              ]
            )
            5)
        );

      # Bindings that works on lockscreens
      bindl = [
        # Media controls
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"

        # Volume controls
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];

      # Repeating bindings that works on lockscreens
      bindel = [
        # Volume controls
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      exec-once = [
        "waybar"
        "swaybg -i ~/.background-image"
      ];

      decoration = {
        rounding = 4;
        rounding_power = 2.0;
        active_opacity = 1;
        inactive_opacity = 1;
        fullscreen_opacity = 1;
        dim_inactive = false;
        border_part_of_window = true;

        blur = {
          enabled = true;
          size = 8;
        };

        shadow = {
          enabled = true;
          range = 4;
        };
      };

      animation = [
        "workspaces, 1, 4, default"
        "fade, 1, 1, default"
      ];

      input = {
        touchpad = {
          natural_scroll = true;
        };
        kb_layout = "us,dk";
        kb_options = [
          "caps:swapescape"
        ];
      };

      monitor = [
        "DP-1, 3840x2160@120, 0x0, 1.5"
        "DP-2, 1920x1080@240, 2560x0, 1"
        ", preferred, auto, 1"
      ];

      plugin = {
        "split-monitor-workspaces" = {
          count = 5;
          keep_focused = 0;
          enable_notifications = 0;
          enable_persistent_workspaces = 1;
        };
      };
    };

    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
  };

  home.file.".background-image" = {
    source = ../../../fractal-flower.jpg;
  };

  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = 150;
            on-timeout = "brightnessctl -l -c backlight -m | cut -d , -f1 | while IFS= read -r dev; do brightnessctl -d $dev -s set 10; done";
            on-resume = "brightnessctl -l -c backlight -m | cut -d , -f1 | while IFS= read -r dev; do brightnessctl -d $dev -r; done";
          }
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          # DPMS on does not work
          # {
          #   timeout = 360;
          #   on-timeout = "hyprctl dispatch dpms off";
          #   on-resume = "hyprctl dispatch dpms on && brightnessctl -l -c backlight -m | cut -d , -f1 | while IFS= read -r dev; do brightnessctl -d $dev -r; done";
          # }
        ];
      };
    };

    network-manager-applet.enable = true;
  };

  programs = {
    hyprlock = {
      enable = true;
      settings = {
        general = {
          no_fade_in = false;
          hide_cursor = false;
          disable_loading_bar = true;
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 7;
          }
        ];

        label = [
          {
            text = ''cmd[update:1000] date +"%d %B %Y"'';
            color = "rgba(242, 243, 244, 0.75)";
            font_size = 22;
            font_family = "JetBrainsMono NF";
            position = "0, 300";
            halign = "center";
            valign = "center";
          }
          {
            text = ''$TIME'';
            color = "rgba(242, 243, 244, 0.75)";
            font_size = 95;
            font_family = "JetBrainsMono NF ExtraBold";
            position = "0, 200";
            halign = "center";
            valign = "center";
          }
          {
            text = "$USER";
            color = "rgba(242, 243, 244, 0.75)";
            font_size = 14;
            font_family = "JetBrainsMono NF";
            position = "0, -120";
            halign = "center";
            valign = "center";
          }
          # {
          #   # Doesn't work for some reason
          #   text = ''cmd[update:1000] echo $(playerctl metadata --format "{{ title }} - {{ artist }}" || echo "No music playing")'';
          #   color = "rgba(242, 243, 244, 0.75)";
          #   font_size = 18;
          #   font_family = "JetBrainsMono NF";
          #   position = "0, 50";
          #   halign = "center";
          #   valign = "bottom";
          # }
        ];

        input-field = [
          {
            size = "350, 60";
            outline_thickness = 2;
            dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
            dots_spacing = 0.35; # Scale of dots' absolute size, 0.0 - 1.0
            dots_center = true;
            outer_color = "rgba(0, 0, 0, 0)";
            inner_color = "rgba(0, 0, 0, 0.2)";
            font_color = "rgba(242, 243, 244, 0.75)";
            fade_on_empty = false;
            rounding = -1;
            check_color = "rgb(204, 136, 34)";
            placeholder_text = ''<i>Password</i>'';
            hide_input = false;
            position = "0, -200";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };

    waybar = {
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
            format-wifi = "";
            format-ethernet = " ";
            format-disconnected = "";
            tooltip-format-disconnected = "Error";
            tooltip-format-wifi = "{essid} ({signalStrength}%) ";
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

    bemenu = {
      enable = true;
      settings = {
        line-height = 28;
        prompt = "open";
        ignorecase = true;
        width-factor = 0.3;
        center = true;
      };
    };
  };

  home.packages = with pkgs; [
    waytrogen
    swaybg
    brightnessctl
    playerctl

    libnotify
    grim
    slurp
  ];
}
