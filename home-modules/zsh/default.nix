{
  flake.homeModules.zsh =
    { lib, ... }:
    {
      programs.starship = {
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

      programs.zsh = {
        enable = true;
        syntaxHighlighting.enable = true;
        autocd = true;

        enableCompletion = true;
        completionInit = "autoload -U compinit -d $HOME/.cache/zsh/zcompdump && compinit -d $HOME/.cache/zsh/zcompdump";

        historySubstringSearch = {
          enable = true;
          searchUpKey = [ "$terminfo[kcuu1]" "^[[A" ];
          searchDownKey = [ "$terminfo[kcud1]" "^[[B" ];
        };
        history = {
          path = "$HOME/.cache/zsh/hist";
          size = 10000;
          save = 10000;
          saveNoDups = true;
        };

        initContent = ''
          bindkey "^[[3~" delete-char # delete

          bindkey "^[[1;5C" forward-word # ctrl-right
          bindkey "^[[1;5D" backward-word # ctrl-left
        '';
      };
    };
}
