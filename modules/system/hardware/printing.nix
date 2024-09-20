{ lib, config, ... }:
with lib;
let
  cfg = config.modules.system.hardware.printing;
in {
  options.modules.system.hardware.printing = {
    enable = mkEnableOption "Enable printing service";
  };

  config = mkIf cfg.enable {
    # Enable printing
    services.printing.enable = true;

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
  };
}
