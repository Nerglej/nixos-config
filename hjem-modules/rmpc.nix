{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.wil.rmpc;
in
{
  options.wil.rmpc = {
    enable = mkEnableOption "rmpc";
  };

  config = mkIf cfg.enable {
    packages = with pkgs; [ rmpc ];

    xdg.config.files."rmpc/config.ron".source = ./rmpc/config.ron;
    xdg.config.files."rmpc/themes".source = ./rmpc/themes;

    wil.mpd = {
      enable = true;
      musicDir = "~/Music";
      network.startWhenNeeded = true;
    };
  };
}
