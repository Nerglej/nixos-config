{
  flake.nixosModules.sddm-astronaut =
    { pkgs, ... }:
    {
      services.displayManager.sddm = {
        enable = true;
        package = pkgs.kdePackages.sddm;
        theme = "sddm-astronaut-theme";
      };

      environment.systemPackages = with pkgs; [
        sddm-astronaut
        kdePackages.qtmultimedia
      ];
    };

  flake.nixosModules.sddm-catppuccin =
    { pkgs, ... }:
    {
      services.displayManager.sddm = {
        enable = true;
        theme = "catppuccin-mocha";
        package = pkgs.kdePackages.sddm;
      };

      environment.systemPackages = with pkgs; [
        (catppuccin-sddm.override {
          flavor = "mocha";
          # font= "";
          fontSize = "9";
          # background = ./;
          loginBackground = true;
        })
      ];
    };
}
