_: {
  programs = {
    hyprlock = {
      enable = true;
      settings = {
        general = {
          no_fade_in = false;
          hide_cursor = false;
          disable_loading_bar = true;
        };

        # background = [
        #    {
        #      path = "screenshot";
        #      blur_passes = 3;
        #      blur_size = 7;
        #    }
        # ];

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

        # input-field = [
        #   {
        #     size = "350, 60";
        #     outline_thickness = 2;
        #     dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        #     dots_spacing = 0.35; # Scale of dots' absolute size, 0.0 - 1.0
        #     dots_center = true;
        #     outer_color = "rgba(0, 0, 0, 0)";
        #     inner_color = "rgba(0, 0, 0, 0.2)";
        #     font_color = "rgba(242, 243, 244, 0.75)";
        #     fade_on_empty = false;
        #     rounding = -1;
        #     check_color = "rgb(204, 136, 34)";
        #     placeholder_text = ''<i>Password</i>'';
        #     hide_input = false;
        #     position = "0, -200";
        #     halign = "center";
        #     valign = "center";
        #   }
        # ];
      };
    };
  };
}
