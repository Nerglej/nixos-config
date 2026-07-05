{ lib, ... }:
{
  options = with lib; {
    name = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Regex pattern to match the monitor by name.
        When null, the attribute name is used as the match value.
      '';
      example = "DP-.*";
    };

    make = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Regex pattern to match the monitor by manufacturer.
      '';
      example = "LG Electronics";
    };

    model = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Regex pattern to match the monitor by model.
      '';
      example = "27GN950-B";
    };

    serial = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Regex pattern to match the monitor by serial number.
      '';
      example = "12345678";
    };

    width = mkOption {
      type = types.int;
      description = ''
        Horizontal resolution of the monitor in pixels.
      '';
      example = 3840;
    };

    height = mkOption {
      type = types.int;
      description = ''
        Vertical resolution of the monitor in pixels.
      '';
      example = 2160;
    };

    refresh = mkOption {
      type = types.float;
      description = ''
        Refresh rate of the monitor in Hertz (Hz).
      '';
      example = 144.0;
    };

    x = mkOption {
      type = types.float;
      default = 0.0;
      description = ''
        Horizontal position of the monitor in the global layout,
        measured in logical pixels after scaling.
      '';
      example = 0.0;
    };

    y = mkOption {
      type = types.float;
      default = 0.0;
      description = ''
        Vertical position of the monitor in the global layout,
        measured in logical pixels after scaling.
      '';
      example = 540.0;
    };

    scale = mkOption {
      type = types.float;
      default = 1.0;
      description = ''
        Output scaling factor applied to the monitor.

        Values greater than 1.0 increase UI size (HiDPI),
        values less than 1.0 decrease it.
      '';
      example = 1.3333;
    };

    rr = mkOption {
      type = types.ints.between 0 7;
      default = 0;
      description = ''
        Monitor transform/rotation value.

        0 = normal, 1 = 90°, 2 = 180°, 3 = 270°,
        4-7 = same rotations with vertical flip applied.
      '';
      example = 1;
    };

    vrr = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enables variable refresh rate for the specified monitor,
        if the compositor supports it.
      '';
    };

    custom = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable custom mode for the monitor.
        May cause issues on unsupported displays.
      '';
    };
  };
}
