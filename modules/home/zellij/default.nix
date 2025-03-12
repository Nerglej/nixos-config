{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.home.shell.zellij;
in {
  options.modules.home.shell.zellij = {
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
