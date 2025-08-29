{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./waybar
    ./hyprlock
    ./hypridle
    ./swaync
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
    ];

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
          "$mod, SPACE, exec, bemenu-run -c -p \"Open\" -l 10"

          # Screenshot
          ''$mod SHIFT, S, exec, REGION=$(slurp) IMG_PATH=~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png || exit; grim -g "$REGION" - | wl-copy &&  wl-paste > "$IMG_PATH" && notify-send -i "$IMG_PATH" -t 1500 -a "Screenshot utility" "Screenshot" "Partial screenshot taken" ''
          ''$mod CTRL SHIFT, S, exec, IMG_PATH=~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png || grim - | wl-copy && wl-paste > "$IMG_PATH" && notify-send -i "$IMG_PATH" -t 1500 -a "Screenshot utility" "Screenshot" "Fullscreen screenshot taken" ''

          # Powermenu
          "$mod SHIFT, P, exec, bemenu-powermenu"

          # Reload hyprland and send a inotify reload to waybar at .config/waybar/config.json
          "$mod, Escape, exec, hyprctl reload && hyprpm reload -f -n && sleep 0.2 && touch -m $APP_FOLDER/waybar/config.jsonc"
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
        ", XF86MonBrightnessUp, exec, brightnessctl set 10%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
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

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_min_fingers = true;
      };

      monitor = [
        "DP-1, 3840x2160@120, 0x0, 1.5"
        "DP-2, 1920x1080@240, 2560x0, 1"
        "eDP-1, 1920x1080@60, 0x0, 1"
        ", preferred, auto, 1"
      ];

      xwayland.force_zero_scaling = true;
      misc.disable_hyprland_logo = true;

      plugin = {
        "split-monitor-workspaces" = {
          count = 5;
          keep_focused = 1;
          enable_notifications = 0;
          enable_persistent_workspaces = 1;
        };
      };
    };
  };

  home.file.".background-image" = {
    source = ../../../fractal-flower.jpg;
  };

  services = {
    network-manager-applet.enable = true;
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
