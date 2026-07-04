{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.wil.wallpapers;
in
{
  options.wil.wallpapers = {
    enable = mkEnableOption "wallpapers";
  };

  config = mkIf cfg.enable {
    files."Pictures/Wallpapers".source = ../media/wallpapers;
  };
}
