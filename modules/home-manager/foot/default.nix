{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.wij.foot;
in
{
  options.wij.foot = {
    enable = lib.mkEnableOption "enable foot";
  };

  config = lib.mkIf cfg.enable {
    programs.foot = {
      enable = true;

      settings.main.font = "CommitMono Nerd Font:size=12";
    };

    home.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
  };
}
