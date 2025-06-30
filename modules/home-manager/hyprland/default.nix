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
          # Close current window
          "$mod, Q, killactive,"

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
          "$mod, F, exec, firefox"

          # Locale changes
          "$mod, M, exec, hyprctl switchxkblayout all next"
          "$mod, SPACE, exec, bemenu-run -c -p \"Open\" -l 10 -W 0.2"
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
      bindle = [
        # Volume controls
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"
      ];

      exec-once = [
        "waybar"
        "swaybg -i ~/.background-image"
      ];

      decoration = {
        rounding = 8;
        active_opacity = 1;
        inactive_opacity = 0.9;
        fullscreen_opacity = 1;
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

          modules-left = ["hyprland/workspaces"];
          modules-center = ["hyprland/window"];
          modules-right = ["tray" "privacy" "hyprland/language" "pulseaudio" "battery" "clock"];

          "tray" = {
            spacing = 10;
          };

          "battery" = {};

          "hyprland/workspaces" = {
            format = "{name} {windows}";
            format-icons = {
              urgent = "";
              active = "";
              visible = "";
              default = "";
              empty = "";
            };
            window-rewrite-default = "";
            window-rewrite = {
              "class<firefox>" = "";
              "foot" = "";
              "class<discord>" = "";
              "class<spotify>" = "";
            };
            all-outputs = false;
          };

          "hyprland/window" = {
            format = "{title}";
            separate-outputs = true;
          };

          "hyprland/language" = {
            format = "{}";
            format-en = "us 🦅";
            format-da = "da 🇩🇰";
            on-click = "hyprctl switchxkblayout all next";
          };

          "pulseaudio" = {
            min-volume = 0;
            max-volume = 100;
            format = "{icon} {volume}%";
            format-bluetooth = "{icon} {volume}% ";
            format-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              phone-muted = "";
              portable = "";
              car = "";
              default = ["" ""];
            };
            scroll-step = 5;
          };

          "clock" = {
            format = "{:%H:%M}";
            interval = 60;
            tooltip = true;
            tooltip-format = "{:%Y-%m-%d %H:%M}";
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
                type = "audio-out";
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
    dunst
    waytrogen
    swaybg
    brightnessctl
    playerctl
  ];
}
