{
  inputs,
  ...
}:
{
  flake.nixosModules.stylix =
    { pkgs, ... }:
    {
      imports = [
        inputs.stylix.nixosModules.stylix
      ];

      stylix = {
        enable = true;
        base16Scheme = ./themes/gruvbox-dark-custom.yaml;

        icons = {
          enable = true;
          package = pkgs.dracula-icon-theme;
          light = "Dracula";
          dark = "Dracula";
        };
      };
    };
}
