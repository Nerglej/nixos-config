{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.system.shell.zsh;
in {
  options.modules.system.shell.zsh = {
    enable = mkEnableOption "Enable the zsh shell";

    defaultShell = mkOption {
      type = types.bool;
      default = false;
      description = "Defines whether zsh should be the default shell for this system";
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "history"
          "rust"
        ];
      };
    };

    users = mkIf cfg.defaultShell {
      defaultUserShell = pkgs.zsh;
    };
  };
}
