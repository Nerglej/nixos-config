{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.wij.shell.zellij;
in
{
  options.wij.shell.zellij = {
    enable = mkEnableOption "Enable zellij";
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      # This option made me not able to do certain custom stuff.
      # So I simply removed it, and it's much better.
      # enableZshIntegration = true;
    };

    home.file.".config/zellij/config.kdl" = {
      source = ./config.kdl;
    };

    home.file.".config/zellij/layouts" = {
      source = ./layouts;
      recursive = true;
    };
  };
}
