{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.zealand.jetbrains;
in {
  options.zealand.jetbrains = {
    enable = mkEnableOption "Enable jetbrains tools development for Zealand";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      jetbrains.idea-ultimate
    ];
  };
}
