{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.wil.shell.direnv;
in
{
  options.wil.shell.direnv = {
    enable = mkEnableOption "direnv";
    zshIntegration.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable && config.wil.shell.zsh.integrations.enable;
      description = "Enable direnv zsh integration";
    };
  };

  config = mkIf cfg.enable {
    rum.programs.direnv = {
      enable = true;
      package = pkgs.direnv;
      integrations.nix-direnv.enable = true;

      # Disable logging (silent)
      settings.global.log_format = "-";
    };
  };
}
