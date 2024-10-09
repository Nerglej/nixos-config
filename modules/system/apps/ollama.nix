{ lib, config, pkgs-unstable, ... }:
with lib;
let
  cfg = config.modules.system.apps.ollama;
in {
  options.modules.system.apps.ollama = {
    enable = mkEnableOption "Enable ollama";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs-unstable.ollama
    ];
  };
}
