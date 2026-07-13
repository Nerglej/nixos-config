{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib) types;

  cfg = config.wil.librewolf;

  # librewolf doubled since it follows mozilla/firefox pattern, but renamed.
  profileRoot = "librewolf/librewolf";

  # Shared by all profiles; will not be supported by future browser versions.
  extensionPath = "extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}";

  ffAddons = pkgs.nur.repos.rycee.firefox-addons;
  baseExtensions = with ffAddons; [
    ublock-origin
    sponsorblock
    sidebery
  ];

  ublockFilterLists = [
    "ublock-filters"
    "ublock-badware"
    "ublock-privacy"
    "ublock-quick-fixes"
    "ublock-unbreak"
    "fanboy-cookiemonster"
    "ublock-cookies-easylist"
  ];

  userJs = ''
    user_pref("webgl.disabled", false);
    user_pref("network.cookie.lifetimePolicy", 0);
    user_pref("privacy.clearOnShutdown.history", false);
    user_pref("privacy.clearOnShutdown.cookies", true);
    user_pref("privacy.resistFingerprinting", false);
    user_pref("privacy.fingerprintingProtection", true);
    user_pref("privacy.fingerprintingProtection.overrides", "+AllTargets,-CSSPrefersColorScheme");
    user_pref("extensions.autoDisableScopes", 0);
    user_pref("extensions.update.autoUpdateDefault", false);
    user_pref("extensions.update.enabled", false);
    user_pref("browser.tabs.inTitlebar", 0);
    user_pref("browser.toolbars.bookmarks.visibility", "never");
    user_pref("browser.profiles.enabled", false);
    user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
    // Read storage.local from browser-extension-data/*/storage.js (makes the uBlock seed readable).
    user_pref("extensions.webextensions.ExtensionStorageIDB.enabled", false);
  '';

  userChrome = ''
    #TabsToolbar{ visibility: collapse !important }
  '';

  package = pkgs.librewolf.override {
    nativeMessagingHosts = lib.optionals cfg.passwordStoreIntegration [ pkgs.passff-host ];

    extraPolicies = {
      SearchEngines = {
        Default = "DuckDuckGo";
        Add = [
          {
            Name = "Nix Packages";
            Alias = "@np";
            URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
            IconURL = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          }
          {
            Name = "Nix Options";
            Alias = "@no";
            URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
          }
        ];
      };

      Extensions.Locked = [
        "uBlock0@raymondhill.net"
        "sponsorBlocker@ajay.app"
        "{3c078156-979c-498b-8990-85f7987dd929}" # sidebery
        "passff@invicem.pro"
        "jetpack-extension@dashlane.com"
      ];
    };
  };

  mkProfileFiles =
    name: profile:
    let
      extEnv = pkgs.buildEnv {
        name = "librewolf-${name}-extensions";
        paths = baseExtensions ++ profile.extraExtensions;
      };
    in
    {
      "${profileRoot}/${name}/user.js".text = userJs;
      "${profileRoot}/${name}/chrome/userChrome.css".text = userChrome;
      "${profileRoot}/${name}/extensions".source = "${extEnv}/share/mozilla/${extensionPath}";
      "${profileRoot}/${name}/browser-extension-data/uBlock0@raymondhill.net/storage.js".text =
        builtins.toJSON
          { selectedFilterLists = ublockFilterLists; };

    };

  profilesIni = lib.generators.toINI { } (
    (lib.mapAttrs' (
      name: profile:
      lib.nameValuePair "Profile${toString profile.id}" {
        Name = name;
        Path = name;
        IsRelative = 1;
        Default = if profile.isDefault then 1 else 0;
      }
    ) cfg.profiles)
    // {
      General = {
        StartWithLastProfile = 1;
        Version = 2;
      };
    }
  );
in
{
  options.wil.librewolf = {
    enable = mkEnableOption "librewolf";

    passwordStoreIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Add passff-host as a native-messaging host for pass integration.";
    };

    profiles = mkOption {
      default = { };
      description = "Librewolf profiles, keyed by profile name.";
      type = types.attrsOf (
        types.submodule {
          options = {
            id = mkOption {
              type = types.int;
              description = "Profile index for profiles.ini; increment by one per profile.";
              example = 1;
            };
            isDefault = mkOption {
              type = types.bool;
              default = false;
            };
            extraExtensions = mkOption {
              type = types.listOf types.package;
              default = [ ];
              example = lib.literalExpression "[ pkgs.nur.repos.rycee.firefox-addons.passff ]";
              description = "Extra addons installed into this profile only.";
            };
          };
        }
      );
    };
  };

  config = mkIf cfg.enable {
    packages = [ package ];

    xdg.config.files = mkMerge (
      [ { "${profileRoot}/profiles.ini".text = profilesIni; } ]
      ++ lib.mapAttrsToList mkProfileFiles cfg.profiles
    );
  };
}
