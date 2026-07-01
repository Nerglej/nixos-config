{
  flake.modules.hjem.shell = { pkgs, lib, ... }: {
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

    rum.programs.zsh = {
      enable = true;
      integrations.starship.enable = true;

      initConfig = ''
        autoload -U compinit -d $HOME/.cache/zsh/zcompdump && compinit -d $HOME/.cache/zsh/zcompdump

        HISTFILE="$HOME/.cache/zsh/history"
        mkdir -p "$(dirname "$HISTFILE")"

        HISTSIZE="10000"
        SAVEHIST="10000"
        setopt HIST_SAVE_NO_DUPS

        setopt autocd

        bindkey "^[[3~" delete-char # delete
        bindkey "^[[1;5C" forward-word # ctrl-right
        bindkey "^[[1;5D" backward-word # ctrl-left

        alias -- l='ls -lah'
        alias -- la='ls -lAh'
        alias -- ll='ls -lh'
        alias -- ls='ls -G'
        alias -- lsa='ls -lah'
      '';

      plugins.syntax-highlighting = {
        source = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
        config = ''
          ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
        '';
      };

      plugins.history-substring-search = {
        source = "${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh";
        config = ''
          bindkey "$terminfo[kcuu1]" history-substring-search-up
          bindkey "^[[A" history-substring-search-up

          bindkey "$terminfo[kcud1]" history-substring-search-down
          bindkey "^[[B" history-substring-search-down
        '';
      };
    };
  };
}
