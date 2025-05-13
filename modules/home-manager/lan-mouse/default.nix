{
  lib,
  config,
  pkgs,
  ...
}: {
    home.packages = with pkgs; [
        lan-mouse
    ];

    home.file."./.config/lan-mouse/config.toml" = {
      source = ./config.toml;
    };
}

