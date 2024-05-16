{ host, nixpkgs, ... }:

{
  "${ host.system }" = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ 
      ./configuration.nix 
    ];
    specialArgs = {
      inherit host;
    };
  };
}
