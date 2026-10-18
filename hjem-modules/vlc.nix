{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.wil.vlc;
in
{
  options.wil.vlc = {
    enable = mkEnableOption "vlc";
  };

  config = mkIf cfg.enable {
    packages = with pkgs; [ vlc ];
  };
}
