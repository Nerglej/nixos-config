{
  flake.nixosModules = {
    hardware = ./hardware;
    sddm = ./sddm;
    stylix = ./stylix;
  };
}
