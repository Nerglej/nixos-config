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

      profiles = {
        "williamj" = {
          id = 0;
          isDefault = true;

          search.default = "ddg";
          search.engines = {
            "Nix Packages" = {
              definedAliases = [ "@np" ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "Nix Options" = {
              definedAliases = [ "@no" ];
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
          };

          extensions = {
            force = true;
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              ublock-origin
              sponsorblock
            ];
            settings."uBlock0@raymondhill.net".settings = {
              selectedFilterLists = [
                "ublock-filters"
                "ublock-badware"
                "ublock-privacy"
                "ublock-unbreak"
                "ublock-quick-fixes"
              ];
            };
          };
        };
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
