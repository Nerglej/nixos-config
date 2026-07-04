{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.wil.imv;
in
{
  options.wil.imv = {
    enable = mkEnableOption "imv";
  };

  config = mkIf cfg.enable {
    rum.programs.imv = {
      enable = true;
    };
  };
}
