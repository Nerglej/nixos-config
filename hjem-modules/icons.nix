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

  cfg = config.wil.icons;
in
{
  options.wil.icons = {
    enable = mkEnableOption "icons";

    package = mkOption {
      type = types.package;
      default = pkgs.dracula-icon-theme;
    };

    name = mkOption {
      type = types.str;
      default = "Dracula";
    };
  };

  config = mkIf cfg.enable {
    xdg.data.files."icons/${cfg.name}".source = "${cfg.package}/share/icons/${cfg.name}";

    rum.misc.gtk = {
      enable = true;
      packages = [ cfg.package ];
      settings = {
        icon-theme-name = cfg.name;
        application-prefer-dark-theme = true;
      };
    };
  };
}
