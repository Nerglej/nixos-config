{
  flake.homeModules.zsh =
    { lib, ... }:
    {
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

        history.path = "$HOME/.cache/zsh/hist";

        initContent = lib.mkBefore "source ${./.zshrc}";
      };
    };
}
