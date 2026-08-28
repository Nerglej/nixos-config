{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;
  inherit (lib) optionalString;

  cfg = config.wil.shell.zsh;
in
{
  options.wil.shell.zsh = {
    enable = mkEnableOption "zsh";
    integrations.enable = mkEnableOption "default to zsh integrations";
  };

  config = mkIf cfg.enable {
    packages = with pkgs; [ zsh ];

    environment.sessionVariables = {
      ZDOTDIR = "${config.xdg.config.directory}/zsh";
    };

    files.".zshenv" = mkIf (config.environment.sessionVariables != { }) {
      source = config.environment.loadEnv;
    };

    xdg.config.files."zsh/.zshrc".text = ''
      # Plugins

      # history substring search
      source "${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
      bindkey "$terminfo[kcuu1]" history-substring-search-up
      bindkey "^[[A" history-substring-search-up

      bindkey "$terminfo[kcud1]" history-substring-search-down
      bindkey "^[[B" history-substring-search-down

      # syntax highlighting
      source "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
      ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)

      # Make XDG dirs if they don't exist
      [ -d ${config.xdg.cache.directory}/zsh ] || mkdir -p ${config.xdg.cache.directory}/zsh
      [ -d ${config.xdg.state.directory}/zsh ] || mkdir -p ${config.xdg.state.directory}/zsh

      autoload -U compinit -d ${config.xdg.cache.directory}/zsh/zcompdump-$ZSH_VERSION && compinit -d ${config.xdg.cache.directory}/zsh/zcompdump-$ZSH_VERSION

      zstyle ':completion:*' cache-path ${config.xdg.cache.directory}/zsh/zcompcache

      HISTFILE="${config.xdg.state.directory}/zsh/history"

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
    ''
    + optionalString config.wil.shell.starship.zshIntegration.enable ''
      eval "$(${pkgs.starship}/bin/starship init zsh)"
    ''
    + optionalString config.wil.shell.direnv.zshIntegration.enable ''
      eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
    ''
    + optionalString config.wil.shell.devenv.zshIntegration.enable ''
      eval "$(${pkgs.devenv}/bin/devenv hook zsh)"
    '';
  };
}
