{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.wil.shell.devenv;
in
{
  options.wil.shell.devenv = {
    enable = mkEnableOption "devenv";
    zshIntegration.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable && config.wil.shell.zsh.integrations.enable;
      description = "Enable devenv zsh integration";
    };
  };

  config = mkIf cfg.enable {
    packages = with pkgs; [ devenv ];
  };
}
