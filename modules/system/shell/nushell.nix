{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.shell.nushell;
in {
  options.shell.nushell = {
    enable = mkEnableOption "Enable nushell";

    defaultShell = mkOption {
      type = types.bool;
      default = false;
      description = "Defines whether nushell should be the default shell";
# Not implemented
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.nushell
    ];

    users = mkIf cfg.defaultShell {
      defaultUserShell = pkgs.nushell;
    };
  };
}
