{
  description = "Williams NixOS flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    
    home-manager = { 
      url = "github:nix-community/home-manager/release-23.11"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixos-wsl, home-manager, ... }:
  let 
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
    };

    hosts = [
      { 
        system = "laptop"; 
        users = [
          "williamj"
        ]; 
      }
      { 
        system = "wsl"; 
        users = [
          "williamj"
        ];
      }
    ];


    mkNixHost = { host }: 
      nixpkgs.lib.nixosSystem 
        (import ./systems/${ host.system } { inherit host nixos-wsl; });

    mkNixConfig = { hosts }: 
      builtins.listToAttrs (
        builtins.map (host: { 
            name = host.system; 
            value = mkNixHost { 
              inherit host; 
            };
          }
        ) hosts
      );

    mkHomeManagerUser = { user }:
      home-manager.lib.homeManagerConfiguration
        (import ./homes/${ user } { inherit user pkgs inputs; });

    mkHomeManagerConfig = { hosts }:
      builtins.listToAttrs (
        builtins.concatLists (
          builtins.map (host: (
              builtins.map (user: {
                  name = "${user}@${host.system}";
                  value = mkHomeManagerUser { inherit user; };
                }
              ) host.users
            )
          ) hosts
        )
      );
  in {
    nixosConfigurations = mkNixConfig { inherit hosts; };
    homeConfigurations = mkHomeManagerConfig { inherit hosts; };

    # homeConfigurations = {
    #   "williamj@laptop" = home-manager.lib.homeManagerConfiguration 
    #     (import ./homes/williamj { inherit pkgs inputs; });
    # };
  };
}
