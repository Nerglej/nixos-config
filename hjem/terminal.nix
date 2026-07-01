{
  flake.modules.hjem.terminal = { pkgs, lib, ... }: {
    rum.programs.foot = {
      enable = true;
      settings = {
        main.font = "CommitMono Nerd Font:size=12";
        main.include = "~/.config/foot/themes/noctalia";
        mouse.hide-when-typing = "yes";

        colors-dark.alpha = 0.9;
        colors-light.alpha = 0.8;
      };
    };
  };
}
