{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.system.shell.nushell;
in {
  options.modules.system.shell.nushell = {
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
