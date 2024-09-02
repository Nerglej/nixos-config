{ lib, config, pkgs, ... }:
with lib;
let 
  cfg = config.apps.steam;
in {
  options.apps.steam = {
    enable = mkEnableOption "Enable steam with defaults";
  };

  config = mkIf cfg.enable {
    hardware.opengl.driSupport32Bit = true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    environment.systemPackages = [ pkgs.steam ];
  };
}
