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
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };

        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };

        monospace = {
          package = pkgs.commit-mono;
          name = "CommitMono Nerd Font";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };

      icons = {
        enable = true;
        package = pkgs.dracula-icon-theme;
        light = "Dracula";
        dark = "Dracula";
      };

      opacity.terminal = 0.9;
    };
  };
}
