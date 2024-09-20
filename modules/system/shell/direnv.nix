{ lib, config, ... }:
with lib;
let
  cfg = config.modules.system.shell.direnv;
in {
  options.modules.system.shell.direnv = {
    enable = mkEnableOption "Enable direnv";
    
    silent = mkOption {
      type = types.bool;
      default = false;
      description = "Defines whether direnv log to the console or to remain silent";
    };
  };

  config = mkIf cfg.enable {
    programs.direnv.enable = true;
    programs.direnv.silent = cfg.silent;
  };
}
