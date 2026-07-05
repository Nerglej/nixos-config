{
  flake.homeModules.mangowc =
    {
      inputs,
      pkgs,
      lib,
      config,
      ...
    }:
    let
      mangoMonitors = map (
        value:
        let
          optionalField = field: key: if field != null then ",${key}:${field}" else "";
        in
        "monitorrule="
        + optionalField value.name "name"
        + optionalField value.make "make"
        + optionalField value.model "model"
        + optionalField value.serial "serial"
        + ",width:${toString value.width}"
        + ",height:${toString value.height}"
        + ",refresh:${toString value.refresh}"
        + ",x:${toString value.x}"
        + ",y:${toString value.y}"
        + ",scale:${toString value.scale}"
        + ",rr:${toString value.rr}"
        + ",vrr:${if value.vrr then "1" else "0"}"
        + ",custom:${if value.custom then "1" else "0"}"
      ) config.wij.compositor.monitors;
    in
    {
      imports = [
        inputs.mango.hmModules.mango
      ];

      config = {
        wayland.windowManager.mango = {
          enable = true;
          autostart_sh = builtins.readFile ./autostart.sh;
          settings = {
            bind = [
              # Config reloading
              "SUPER,Escape,reload_config,"

              "SUPER+SHIFT,q,killclient"
              "SUPER,q,minimized"
              "SUPER,r,restore_minimized"
              "SUPER,s,toggle_scratchpad"
              "SUPER,f,togglefloating"
              "SUPER+SHIFT,f,togglefullscreen"

              # Window gym
              "SUPER,1,comboview,1"
              "SUPER,2,comboview,2"
              "SUPER,3,comboview,3"
              "SUPER,4,comboview,4"
              "SUPER,5,comboview,5"
              "SUPER,6,comboview,6"
              "SUPER,7,comboview,7"
              "SUPER,8,comboview,8"
              "SUPER,9,comboview,9"

              "SUPER+SHIFT,1,tag,1"
              "SUPER+SHIFT,2,tag,2"
              "SUPER+SHIFT,3,tag,3"
              "SUPER+SHIFT,4,tag,4"
              "SUPER+SHIFT,5,tag,5"
              "SUPER+SHIFT,6,tag,6"
              "SUPER+SHIFT,7,tag,7"
              "SUPER+SHIFT,8,tag,8"
              "SUPER+SHIFT,9,tag,9"

              "SUPER,h,focusdir,left"
              "SUPER,j,focusdir,down"
              "SUPER,k,focusdir,up"
              "SUPER,l,focusdir,right"

              "SUPER,COMMA,viewtoleft"
              "SUPER,PERIOD,viewtoright"
              "SUPER+SHIFT,COMMA,tagtoleft"
              "SUPER+SHIFT,PERIOD,tagtoright"

              "SUPER+SHIFT,h,exchange_client,left"
              "SUPER+SHIFT,j,exchange_client,down"
              "SUPER+SHIFT,k,exchange_client,up"
              "SUPER+SHIFT,l,exchange_client,right"

              "SUPER+ALT,h,setmfact,-0.05"
              "SUPER+ALT,l,setmfact,+0.05"

              "SUPER+SHIFT,o,switch_layout"
              "SUPER+SHIFT,p,switch_proportion_preset"

              # Brightness controls
              "SHIFT,XF86MonBrightnessUp,spawn,brightnessctl set 100%"
              "SHIFT,XF86MonBrightnessDown,spawn,brightnessctl set 1%"

              # App shortcuts
              "SUPER,t,spawn,foot"
              "SUPER,Return,spawn,foot"
              "SUPER,space,spawn,bemenu-run -p Open"
              "SUPER,d,spawn,bemenu-run -p Open"

              "SUPER+ALT,w,spawn,bemenu-zellij-session"
              "SUPER+ALT,e,spawn,bemenu-zellij-projects"

              "SUPER+ALT,o,spawn,bemenu-audio sink"
              "SUPER+ALT,i,spawn,bemenu-audio source"

              "SUPER+SHIFT,S,spawn,snip"

              # Switch keyboard layout
              "SUPER,shift_r,switch_keyboard_layout"
            ];

            bindl = [
              "NONE,XF86AudioPlay,spawn,playerctl play-pause"
              "NONE,XF86AudioPrev,spawn,playerctl previous"
              "NONE,XF86AudioNext,spawn,playerctl next"

              # Mic mute controls
              "NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              "NONE,XF86AudioMicMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

              # Volume controls
              "NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
              "NONE,XF86AudioLowerVolume,spawn,wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"

              # Brightness controls
              "NONE,XF86MonBrightnessUp,spawn,brightnessctl set 10%+"
              "NONE,XF86MonBrightnessDown,spawn,brightnessctl set 10%-"
            ];

            mousebind = [
              # Move windows with cursor
              "SUPER,btn_left,moveresize,curmove"
              "SUPER+ALT,btn_left,moveresize,curresize"
              "SUPER,btn_right,moveresize,curresize"
            ];

            exec-once = [ "noctalia" ];

            circle_layout = "tile,scroller";
            scroller_proportion_preset = "0.5,0.8,1.0";
            scroller_focus_center = 0;
            scroller_prefer_center = 1;

            focus_cross_monitor = 1;
            exchange_cross_monitor = 1;
            focus_cross_tag = 0;
            scratchpad_cross_monitor = 1;

            # Mousing
            warpcursor = 1;
            drag_tile_to_tile = 1;
            enable_hotarea = 0; # disables hover to see overview
            trackpad_natural_scrolling = 1;

            # Keyboard rules
            xkb_rules_layout = "us,dk";
            xkb_rules_options = "caps:escape";

            # Theming
            border_radius = 10;
            borderpx = 2;
            gappih = 5;
            gappiv = 5;
            gappoh = 10;
            gappov = 10;

            # Animation
            animation_duration_move = 200;
            animation_duration_open = 200;
            animation_duration_tag = 350;
            animation_duration_close = 250;
            animation_duration_focus = 0;
          };

          extraConfig = builtins.concatStringsSep "\n" mangoMonitors;
        };

        home.packages = with pkgs; [
          wlr-randr
          brightnessctl
          playerctl
          libnotify
        ];
      };
    };
}
