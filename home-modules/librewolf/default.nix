{
  flake.homeModules.librewolf =
    { pkgs, lib, config, ... }:
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
            "network.cookie.lifetimePolicy" = 0;
            "privacy.clearOnShutdown.history" = false;
            "privacy.clearOnShutdown.cookies" = true;

            # This is temporary, until LibreWolf figures out themselves what they want.
            # This makes system theming viable though.
            # See [#2121](https://codeberg.org/librewolf/issues/issues/2121)
            "privacy.resistFingerprinting" = false;
            "privacy.fingerprintingProtection" = true;
            "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme";
          };

          profiles =
            let
              mkProfile =
                {
                  id,
                  isDefault ? false,
                  extensions ? [ ],
                }:
                {
                  inherit id isDefault;

                  extensions = {
                    force = true;

                    packages =
                      with pkgs.nur.repos.rycee.firefox-addons;
                      [
                        ublock-origin
                        sponsorblock
                        sidebery
                      ]
                      ++ extensions;

                    settings."uBlock0@raymondhill.net".settings = {
                      selectedFilterLists = [
                        "ublock-filters"
                        "ublock-badware"
                        "ublock-privacy"
                        "ublock-unbreak"
                        "ublock-quick-fixes"
                      ];
                    };
                    settings."{3c078156-979c-498b-8990-85f7987dd929}".permissions = [
                      "activeTab"
                      "tabs"
                      "contextualIdentities"
                      "cookies"
                      "storage"
                      "unlimitedStorage"
                      "sessions"
                      "menus"
                      "menus.overrideContext"
                      "search"
                      "theme"
                      "identity"
                      "bookmarks"
                      "history"
                    ];
                  };

                  settings = {
                    "extensions.autoDisableScopes" = 0;
                    "extensions.update.autoUpdateDefault" = false;
                    "extensions.update.enabled" = false;

                    "browser.tabs.inTitlebar" = 0;
                    "browser.toolbars.bookmarks.visibility" = "never";
                    "browser.profiles.enabled" = false;
                    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                  };

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

                  userChrome = ''
                    #TabsToolbar{ visibility: collapse !important }
                  '';

                };
            in
            {
              "general" = mkProfile {
                id = 0;
                isDefault = true;
                extensions = [ pkgs.nur.repos.rycee.firefox-addons.passff ];
              };

              "OptoCeutics" = mkProfile {
                id = 1;
                extensions = [ pkgs.nur.repos.rycee.firefox-addons.dashlane ];
              };

              "Zealand" = mkProfile {
                id = 2;
                extensions = [ ];
              };
            };

          policies = {
            Extensions.Locked = [
              "uBlock0@raymondhill.net"
              "passff@invicem.pro"
              "{3c078156-979c-498b-8990-85f7987dd929}" # sidebery
              "sponsorBlocker@ajay.app"
              "jetpack-extension@dashlane.com"
            ];
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
    };
}
