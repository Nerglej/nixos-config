{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.home.shell.zsh;
in {
  options.modules.home.shell.zsh = {
    enable = mkEnableOption "Enable the zsh shell";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "history"
          "rust"
        ];
      };

      initExtraFirst = "source ${./.zshrc}";
    };
  };
}
