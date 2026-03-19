{
  flake.homeModules.librewolf =
    {
      pkgs,
      lib,
      config,
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

        profiles = lib.mkOption {
          default = {
            "default" = {
              id = 0;
              isDefault = true;
              extraExtensions = [ ];
            };
          };
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                id = lib.mkOption {
                  type = lib.types.int;
                  description = ''
                    Shall always be incremented by one.
                  '';
                  example = 2;
                };
                isDefault = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  example = true;
                };
                extraExtensions = lib.mkOption {
                  type = lib.types.listOf lib.types.package;
                  example = [ pkgs.nur.repos.rycee.firefox-addons.passff ];
                  default = [ ];
                  description = ''
                    Install extra extensions for a profile. To lock them, currently
                    add them to the module itself.
                  '';
                };
              };
            }
          );
          description = ''
            Set up profiles for the browser
          '';
        };

        mimeAppDefault = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Remember to enable `xdf.mimeApps.enable` yourself
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
                        "ublock-quick-fixes"
                        "ublock-unbreak"
                        "fanboy-cookiemonster"
                        "ublock-cookies-easylist"
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

              profiles = builtins.mapAttrs (
                profile: value:
                mkProfile {
                  inherit (value) id isDefault;
                  extensions = value.extraExtensions;
                }
              ) cfg.profiles;
            in
            profiles;

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
