{
  flake.homeModules.zsh =
    { lib, ... }:
    {
      programs.starship = {
        enable = true;
        settings = {
          add_newline = false;
          format = lib.concatStrings [
            "$username"
            "$directory"
            # "\($vcs\)"
            "(\\("
            "$git_branch"
            "$git_commit"
            "$git_state"
            "$git_metrics"
            "$git_status"
            "\\) )"
            "$character"
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

          # vcs = {
          #   order = [ "git" ];
          # };
        };
      };

      programs.zsh = {
        enable = true;
        syntaxHighlighting.enable = true;
        autocd = true;

        enableCompletion = true;
        completionInit = "autoload -U compinit -d $HOME/.cache/zsh/zcompdump && compinit -d $HOME/.cache/zsh/zcompdump";

        history = {
          path = "$HOME/.cache/zsh/hist";
          size = 10000;
          save = 10000;
          saveNoDups = true;
        };
      };
    };
}
