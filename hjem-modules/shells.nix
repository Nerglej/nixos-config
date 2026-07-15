{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.wil.shell;
in
{
  options.wil.shell = {
    enable = mkEnableOption "shell";
  };

  config = mkIf cfg.enable {
    rum.programs.starship = {
      enable = true;

      settings = {
        add_newline = false;
        format = lib.concatStrings [
          "$character  "
          "$username"
          "$directory"
          # "\($vcs\)"
          "[(\\("
          "$git_branch"
          "$git_commit"
          "$git_state"
          "$git_metrics"
          "$git_status"
          "\\) )](bold blue)"
        ];

        git_branch = {
          style = "bold red";
          format = "[$branch(:$remote_branch)]($style)";
        };

        git_status = {
          style = "bold yellow";
          format = "[$all_status$ahead_behind]($style)";
          untracked = "?";
          stashed = "\\$";
          modified = "*";
          staged = "+";
          # renamed = "";
          deleted = "-";
        };

        character = {
          format = "$symbol";
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };

        # vcs = {
        #   order = [ "git" ];
        # };
      };
    };

    rum.programs.direnv = {
      enable = true;
      integrations.nix-direnv.enable = true;

      # Disable logging (silent)
      settings.global.log_format = "-";
    };
  };
}
