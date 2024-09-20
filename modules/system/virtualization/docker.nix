{ lib, config, ... }:

with lib;
let
  cfg = config.modules.system.virtualization.docker;
in {
  options.modules.system.virtualization.docker = {
    enable = mkEnableOption "Enable Docker";

    enableOnBoot = mkOption {
      type = types.bool;
      default = false;
      description = "Defines if Docker should start on startup";
    };

    users = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "A list of users that should be added to the 'docker' extra group";
    };

    rootless = mkOption {
      type = types.bool;
      default = false;
      description = "Defines whether Docker should be rootless or not";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    virtualisation.docker.enableOnBoot = cfg.enableOnBoot;
    users.extraGroups.docker.members = cfg.users;

    virtualisation.docker.rootless = mkIf cfg.rootless {
      enable = true;
      setSocketVariable = true;
    };
  };
}
