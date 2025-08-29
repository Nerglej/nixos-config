_: {
  services.hypridle = {
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
}
