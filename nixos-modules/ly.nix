{
  flake.nixosModules.ly =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      services.displayManager.ly = {
        enable = true;
        x11Support = false;
        settings = {
          animation_frame_delay = 5;
          animation_timeout_sec = 0;

          animation = "dur_file";
          dur_file_path = toString ./blackhole-smooth-240x67.dur;
          dur_offset_alignment = "center";
          dur_x_offset = 0;
          dur_y_offset = 0;
          # animation = "doom";
          # doom_fire_height = 6;
          # doom_fire_spread = 2;
          # doom_top_color = "0x00FF0000";
          # doom_middle_color = "0x00FFFF00";
          # doom_bottom_color = "0x00FFFFFF";
          bigclock = true;
          full_color = true;
        };
      };
    };
}
