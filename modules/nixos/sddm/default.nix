{pkgs, ...}: {
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
}
