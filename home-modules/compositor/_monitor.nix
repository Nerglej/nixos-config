{ lib, ... }:
{
  options = with lib; {
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
      type = types.int;
      description = ''
        Refresh rate of the monitor in Hertz (Hz).
      '';
      example = 144;
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

    enableVariableRefreshRate = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enables variable refresh rate for the specified monitor,
        if the compositor supports it.
      '';
    };
  };
}
