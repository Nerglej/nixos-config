{ pkgs, ... }:

{
  hardware.opengl.driSupport32Bit = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = [ pkgs.steam ];
}
