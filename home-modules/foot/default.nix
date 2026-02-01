{
  flake.homeModules.foot =
    {
      pkgs,
      ...
    }:
    {
      programs.foot = {
        enable = true;

        settings.main.font = "CommitMono Nerd Font:size=12";
      };

      home.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
    };
}
