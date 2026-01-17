{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.wij.librewolf;
in
{
  options.wij.librewolf = {
    enable = lib.mkEnableOption "enable custom librewolf";

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
    programs.librewolf = {
      enable = true;
      package = pkgs.librewolf.override {
        nativeMessagingHosts = (lib.lists.optionals cfg.passwordStoreIntegration [ pkgs.passff-host ]);
      };

      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = true;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
      };

      profiles = {
        "general" = {
          id = 0;
          isDefault = true;

          search = {
            force = true;
            default = "ddg";
            engines = {
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
      "default-web-browser" = [ "librewolf.desktop" ];
      "text/html" = [ "librewolf.desktop" ];
      "x-scheme-handler/http" = [ "librewolf.desktop" ];
      "x-scheme-handler/https" = [ "librewolf.desktop" ];
      "x-scheme-handler/about" = [ "librewolf.desktop" ];
      "x-scheme-handler/unknown" = [ "librewolf.desktop" ];
    };
  };
}
