{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.sddm;
in {
  options.modules.sddm = {
    enable = mkEnableOption "enable sddm";

    theme = mkOption {
      default = "astronaut";
      type = types.enum ["astronaut" "catpuccin"];
      example = "catpuccin";
    };
  };

  config = mkIf cfg.enable (
    mkMerge [
      (mkIf (cfg.theme == "astronaut") {
        services.displayManager.sddm = {
          enable = true;
          package = pkgs.kdePackages.sddm;
          theme = "sddm-astronaut-theme";
        };

        environment.systemPackages = with pkgs; [
          sddm-astronaut
          kdePackages.qtmultimedia
        ];
      })
      (mkIf (cfg.theme == "catpuccin") {
        services.displayManager.sddm = {
          enable = true;
          theme = "catppuccin-mocha";
          package = pkgs.kdePackages.sddm;
        };

        environment.systemPackages = with pkgs; [
          (
            catppuccin-sddm.override {
              flavor = "mocha";
              # font= "";
              fontSize = "9";
              # background = ./;
              loginBackground = true;
            }
          )
        ];
      })
    ]
  );
}
