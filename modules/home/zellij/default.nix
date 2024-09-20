{ lib, config, ... }:
with lib;
let
  cfg = config.modules.home.apps.zellij;
in {
  options.modules.home.apps.zellij = {
    enable = mkEnableOption "Enable zellij";
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
    };

    home.file."./.config/zellij/config.kdl" = {
      source = ./config.kdl;
    };
  };
}
