{
  flake.nixosModules.sddm-astronaut =
    { pkgs, ... }:
    let
      astronaut = pkgs.sddm-astronaut.override {
        embeddedTheme = "black_hole";
      };
    in
    {
      services.displayManager.sddm = {
        enable = true;
        extraPackages = [ astronaut ];
        theme = "sddm-astronaut-theme";
        wayland.enable = true;
      };

      environment.systemPackages = [
        astronaut
        pkgs.kdePackages.qtmultimedia
      ];
    };

  flake.nixosModules.sddm-catppuccin =
    { pkgs, ... }:
    let
      catppucin = pkgs.catppuccin-sddm.override {
        flavor = "mocha";
        # font= "";
        fontSize = "9";
        # background = ./;
        loginBackground = true;
      };
    in
    {
      services.displayManager.sddm = {
        enable = true;
        extraPackages = [ catppucin ];
        theme = "catppuccin-mocha";
        wayland.enable = true;
      };

      environment.systemPackages = [ catppucin ];
    };
}
