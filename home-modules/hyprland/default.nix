{
  flake.homeModules.hyprland =
    { pkgs, inputs, ... }:
    {
      imports = [
        inputs.self.homeModules.hypridle
        inputs.self.homeModules.hyprland-swaync
        inputs.self.homeModules.noctalia-shell
      ];

      home.file.".config/scripts/hypr" = {
        source = ./scripts;
        recursive = true;
      };

      home.sessionPath = [ "$HOME/.config/scripts/hypr" ];

      wayland.windowManager.hyprland = {
        enable = true;

        # Uses the nixos defined packages
        package = null;
        portalPackage = null;

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

          bind = [
            # Current window actions
            "$mod, Q, killactive"
            "$mod, F, togglefloating"
            "$mod SHIFT, F, fullscreen"

            # Move focus
            "$mod, H, movefocus, l"
            "$mod, J, movefocus, d"
            "$mod, K, movefocus, u"
            "$mod, L, movefocus, r"
            "$mod, LEFT, movefocus, l"
            "$mod, DOWN, movefocus, d"
            "$mod, UP, movefocus, u"
            "$mod, RIGHT, movefocus, r"

            "$mod, COMMA, split-workspace, -1"
            "$mod, PERIOD, split-workspace, +1"

            # Move windows
            "$mod SHIFT, H, movewindow, l"
            "$mod SHIFT, J, movewindow, d"
            "$mod SHIFT, K, movewindow, u"
            "$mod SHIFT, L, movewindow, r"
            "$mod SHIFT, LEFT, movewindow, l"
            "$mod SHIFT, DOWN, movewindow, d"
            "$mod SHIFT, UP, movewindow, u"
            "$mod SHIFT, RIGHT, movewindow, r"

            "$mod SHIFT, COMMA, split-movetoworkspace, -1"
            "$mod SHIFT, PERIOD, split-movetoworkspace, +1"

            # Swap windows
            "$mod CTRL SHIFT, H, swapwindow, l"
            "$mod CTRL SHIFT, J, swapwindow, d"
            "$mod CTRL SHIFT, K, swapwindow, u"
            "$mod CTRL SHIFT, L, swapwindow, r"
            "$mod CTRL SHIFT, LEFT, swapwindow, l"
            "$mod CTRL SHIFT, DOWN, swapwindow, d"
            "$mod CTRL SHIFT, UP, swapwindow, u"
            "$mod CTRL SHIFT, RIGHT, swapwindow, r"

            # Some app shortcuts
            "$mod, SPACE, exec, bemenu-run -c -p \"Open\" -l 10"
            "$mod, T, exec, foot"
            "$mod ALT, T, exec, foot"
            "$mod ALT, F, exec, firefox"
            "$mod ALT, M, exec, pgrep spotify && hyprctl dispatch togglespecialworkspace music || spotify &"
            "$mod ALT, P, exec, noctalia-shell ipc call sessionMenu toggle"
            "$mod ALT, O, exec, bemenu-audio sink"
            "$mod ALT, I, exec, bemenu-audio source"

            "$mod ALT, W, exec, bemenu-zellij-session"
            "$mod ALT, E, exec, bemenu-zellij-projects"

            # Locale changes
            "$mod, M, exec, hyprctl switchxkblayout all next"

            # Screenshot
            "$mod SHIFT, S, exec, snip"

            # Reload hyprland and send a inotify reload to waybar at .config/waybar/config.json
            "$mod, Escape, exec, hyprctl reload && hyprpm reload -f -n && sleep 0.2 && touch -m $APP_FOLDER/waybar/config.jsonc"
          ]
          ++ (
            # workspaces
            # binds $mod + [shift +] {1..5} to [move to] workspace
            # {1..5} on the corresponding monitor
            builtins.concatLists (
              builtins.genList (
                i:
                let
                  ws = i + 1;
                in
                [
                  "$mod, code:1${toString i}, split-workspace, ${toString ws}"
                  "$mod CTRL, code:1${toString i}, split-movetoworkspacesilent, ${toString ws}"
                  "$mod SHIFT, code:1${toString i}, split-movetoworkspace, ${toString ws}"
                ]
              ) 5
            )
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

          binde = [
            ", XF86MonBrightnessUp, exec, hypr-brightness +10%"
            ", XF86MonBrightnessDown, exec, hypr-brightness 10%-"
          ];

          windowrule = [
            "match:class spotify, workspace special:music"
          ];

          layerrule = [
            "match:class swaync-control-center, blur on"
            "match:class swaync-control-center, ignore_alpha 0"
            "match:class swaync-control-center, ignore_alpha 0.5"

            "match:class swaync-notification-window, blur on"
            "match:class swaync-notification-window, ignore_alpha 0"
            "match:class swaync-notification-window, ignore_alpha 0.5"
          ];

          general = {
            gaps_in = 5;
            gaps_out = 10;
          };

          decoration = {
            rounding = 10;
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
              "caps:escape"
            ];
          };

          gesture = [
            "3, horizontal, workspace"
            "4, horizontal, workspace"
          ];

          monitor = [
            "DP-1, 3840x2160@120, 0x0, 1.5"
            "DP-2, 1920x1080@240, 2560x180, 1"
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

      home.file."Pictures/Wallpapers/fractal-flower.jpg" = {
        source = ../../fractal-flower.jpg;
      };

      services = {
        network-manager-applet.enable = true;
      };

      home.packages = with pkgs; [
        brightnessctl
        playerctl

        libnotify
        grim
        slurp
      ];
    };
}
