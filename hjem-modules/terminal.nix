{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.wil.terminal;
in
{
  options.wil.terminal = {
    enable = mkEnableOption "terminal";
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      TERMINAL = "foot";
    };

    rum.programs.foot = {
      enable = true;
      settings = {
        main.font = "CommitMono Nerd Font:size=12";
        main.include = "~/.config/foot/themes/noctalia";
        mouse.hide-when-typing = "yes";

        colors-dark.alpha = 0.9;
        colors-light.alpha = 0.8;
      };
    };
  };
}
