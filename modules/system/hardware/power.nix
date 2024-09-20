{ lib, config, ... }:
with lib;
let
  cfg = config.modules.system.hardware.power;
in {
  options.modules.system.hardware.power = {
    enable = mkEnableOption "Enable laptop power saving and performance stuff";
  };

  config = mkIf cfg.enable {
    services.thermald.enable = true;

    services.auto-cpufreq = {
      enable = true;

      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };

        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
  };
}
