{ host, nixos-wsl, ... }:
{
  system = "x86_64-linux";
  modules = [
    nixos-wsl.nixosModules.default
    ./configuration.nix
  ];
  specialArgs = {
    inherit host;
  };
}
