{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;
  inherit (lib) mkOption types;

  cfg = config.wil.cursor;
in
{
  options.wil.cursor = {
    enable = mkEnableOption "cursor";

    package = mkOption {
      type = types.package;
      default = pkgs.bibata-cursors;
    };

    name = mkOption {
      type = types.str;
      default = "Bibata-Modern-Classic";
    };

    size = mkOption {
      type = types.int;
      default = 24;
      example = 32;
    };
  };

  config = mkIf cfg.enable {
    xdg.data.files."icons/${cfg.name}".source = "${cfg.package}/share/icons/${cfg.name}";

    # Fallback so the literal "default" cursor (root pointer, some XWayland
    # apps) resolves to the chosen theme instead of the X11 default.
    xdg.data.files."icons/default/index.theme".text = ''
      [Icon Theme]
      Name=default
      Comment=Default cursor theme
      Inherits=${cfg.name}
    '';

    environment.sessionVariables = {
      XCURSOR_SIZE = toString cfg.size;
      XCURSOR_THEME = cfg.name;
      XCURSOR_PATH = [ "${config.xdg.data.directory}/icons" ];
    };
  };
}
