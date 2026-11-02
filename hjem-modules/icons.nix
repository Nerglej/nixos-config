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

    packages = mkOption {
      type = types.listOf types.package;
      default = [ ];
    };

    icon-theme-package = mkOption {
      type = types.package;
      default = pkgs.dracula-icon-theme;
    };
    icon-theme-name = mkOption {
      type = types.str;
      default = "Dracula";
    };

    prefer-dark-theme = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    xdg.data.files."icons/${cfg.icon-theme-name}".source =
      "${cfg.icon-theme-package}/share/icons/${cfg.icon-theme-name}";

    rum.misc.gtk = {
      enable = true;
      packages = cfg.packages ++ [ cfg.icon-theme-package ];

      gtk2Location = ".config/gtk-2.0/gtkrc";

      settings = {
        inherit (cfg) icon-theme-name;
        application-prefer-dark-theme = cfg.prefer-dark-theme;
      };
    };
  };
}
