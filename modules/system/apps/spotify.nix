{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.system.apps.spotify;
in {
  options.modules.system.apps.spotify = {
    enable = mkEnableOption "Enable spotify app";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.spotify
    ]; 

    networking.firewall.allowedUDPPorts = [ 5353 ];
  };
}
