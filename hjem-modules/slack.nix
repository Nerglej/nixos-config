{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.wil.slack;
in
{
  options.wil.slack = {
    msga.enable = mkEnableOption "msga slack client";
  };

  config = mkIf cfg.msga.enable {
    packages = [ inputs.msga.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
