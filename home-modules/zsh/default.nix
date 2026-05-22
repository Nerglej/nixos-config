{
  flake.homeModules.zsh =
    { lib, ... }:
    {
      programs.starship.enable = true;

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
