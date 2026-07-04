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

  cfg = config.wil.xdg;
in
{
  options.wil.xdg = {
    enable = mkEnableOption "xdg";
    mimeApps = {
      enable = mkEnableOption "mime-apps";
      defaultApplications = mkOption {
        type = types.lines;
        default = "";
      };
      addedAssociations = mkOption {
        type = types.lines;
        default = "";
      };
      removedAssociations = mkOption {
        type = types.lines;
        default = "";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_BIN_HOME = "$HOME/.local/bin";
    };

    xdg.config.files."mimeapps.list" = mkIf cfg.mimeApps.enable {
      text = ''
        [Added Associations]
      ''
      + cfg.mimeApps.addedAssociations
      + ''
        [Removed Associations]
      ''
      + cfg.mimeApps.removedAssociations
      + ''
        [Default Applications]
      ''
      + cfg.mimeApps.defaultApplications;
    };
  };
}
