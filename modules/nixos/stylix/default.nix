{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  config = {
    stylix = {
      enable = true;
      base16Scheme = ./themes/gruvbox-dark-custom.yaml;
      image = ../../../fractal-flower.jpg;
      fonts = {
        monospace = {
          package = pkgs.commit-mono;
          name = "CommitMono Nerd Font";
        };
      };
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };

      opacity.terminal = 0.9;
    };
  };
}
