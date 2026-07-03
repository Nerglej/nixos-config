{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.wil.zellij;
in
{
  options.wil.zellij = {
    enable = mkEnableOption "zellij";
  };

  config = mkIf cfg.enable {
    packages = with pkgs; [
      zellij
    ];

    xdg.config.files."zellij/config.kdl".source = ./zellij/config.kdl;
    xdg.config.files."zellij/layouts".source = ./zellij/layouts;
  };
}
