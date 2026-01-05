{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.wij.firefox;
in
{
  options.wij.firefox = {
    enable = lib.mkEnableOption "enable custom firefox";

    passwordStoreIntegration = lib.mkOption {
      type = lib.types.bool;
      default = config.wij.password-store.enable;
      example = true;
    };

    mimeAppDefault = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Remember to enable `xdf.mimeApps.enable` yourself.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox.override {
        nativeMessagingHosts = (lib.lists.optionals cfg.passwordStoreIntegration [ pkgs.passff-host ]);
      };
    };

    xdg.mimeApps.defaultApplications = lib.mkIf cfg.mimeAppDefault {
      "default-web-browser" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
    };
  };
}
