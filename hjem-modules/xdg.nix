{ lib, config, ... }:
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
    environment.sessionVariables = rec {
      XDG_CACHE_HOME = config.xdg.cache.directory;
      XDG_CONFIG_HOME = config.xdg.config.directory;
      XDG_DATA_HOME = config.xdg.data.directory;
      XDG_STATE_HOME = config.xdg.state.directory;
      XDG_BIN_HOME = "${config.directory}/.local/bin";

      # XDG app specific patches acording to
      # https://wiki.archlinux.org/title/XDG_Base_Directory
      # Cargo
      CARGO_HOME = "${XDG_DATA_HOME}/cargo";
      # NPM
      NPM_CONFIG_USERCONFIG = "${XDG_CONFIG_HOME}/npm/npmrc";
      # Compose
      XCOMPOSEFILE = "${XDG_CONFIG_HOME}/X11/xcompose";
      XCOMPOSECACHE = "${XDG_CACHE_HOME}/X11/xcompose";
    };

    # NPM xdg patches
    xdg.config.files."npm/npmrc".text = ''
      prefix=''${XDG_DATA_HOME}/npm
      cache=''${XDG_CACHE_HOME}/npm
      init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
      logs-dir=''${XDG_STATE_HOME}/npm/logs
    '';

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
