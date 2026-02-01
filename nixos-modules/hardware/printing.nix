{
  flake.nixosModules.printing =
    { pkgs, ... }:
    {
      services.printing.enable = true;

      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
        publish = {
          enable = true;
          userServices = true;
        };
      };
    };
}
