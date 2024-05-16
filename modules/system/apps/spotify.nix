{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    spotify
  ]; 

  networking.firewall.allowedUDPPorts = [ 5353 ];
}
