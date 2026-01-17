{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.wij.shell.zsh;
in
{
  options.wij.shell.zsh = {
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

      initContent = lib.mkBefore "source ${./.zshrc}";
    };
  };
}
