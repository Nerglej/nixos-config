{ host, pkgs-unstable, ... }:

{
  system = "x86_64-linux";
  modules = [ 
    ./hardware-configuration.nix
    ./configuration.nix 
  ];
  specialArgs = {
    inherit host pkgs-unstable;
  };
}
