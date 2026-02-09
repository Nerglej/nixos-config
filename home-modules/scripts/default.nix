{
  flake.homeModules.screenshot-scripts =
    { pkgs, ... }:
    {
      home.file.".config/scripts/screenshots" = {
        source = ./screenshots;
        recursive = true;
      };

      home.sessionPath = [ "$HOME/.config/scripts/screenshots" ];

      home.packages = with pkgs; [
        grim
        slurp
      ];
    };
}
