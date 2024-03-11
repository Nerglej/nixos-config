{ pkgs, ... }:

{
  # Enable printing
  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
}
