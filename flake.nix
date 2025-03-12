{
    description = "Williams NixOS flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

        home-manager.url =  "github:nix-community/home-manager/release-24.11";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { 
        self, 
        nixpkgs, 
        nixpkgs-unstable, 
        nixos-wsl, 
        home-manager, 
        ... 
    } @ inputs: let 
        inherit (self) outputs;

        # All supported systems
        systems = [
            "aarch64-linux"
            "i686-linux"
            "x86_64-linux"
            "aarch64-darwin"
            "x86_64-darwin"
        ];

        forAllSystems = nixpkgs.lib.genAttrs systems;

        system = "x86_64-linux";

        pkgs = import nixpkgs {
            inherit system;

            config = {
                allowUnfree = true;
                allowUnfreePredicate = (_: true);
            };
        };

        pkgs-unstable = import nixpkgs-unstable {
            inherit system;

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
    in {
        # Custom packages
        packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
        # Formatter for nix files
        formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

        overlays = import ./overlays { inherit inputs; };

        # NixOS config entrypoint
        nixosConfigurations = {
            laptop = nixpkgs.lib.nixosSystem {
                specialArgs = { inherit inputs outputs; };
                modules = [
                    ./nixos/laptop
                ];
            };
        };

        # Standalone home-manager configuration entrypoint
        homeConfigurations = {
            "williamj@laptop" = home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.x86_64-linux;
                extraSpecialArgs = { inherit inputs outputs; };
                modules = [
                    ./home-manager/williamj
                ];
            };
        };
        # nixosConfigurations = mkNixConfig { inherit hosts; };
        # homeConfigurations = mkHomeManagerConfig { inherit hosts; };
    };
}
