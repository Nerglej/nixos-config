{
  description = "Williams NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    alejandra.url = "github:kamadorueda/alejandra/3.1.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    alejandra,
    nvf,
    nixos-wsl,
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
  in {
    # Custom packages
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for nix files
    formatter = forAllSystems (system: alejandra.defaultPackage.${system});

    overlays = import ./overlays {inherit inputs;};

    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    # NixOS config entrypoint
    nixosConfigurations = {
      little = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/little
        ];
      };

      emperor = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/emperor
        ];
      };

      wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          nixos-wsl.nixosModules.defaul
          ./nixos/wsl
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    homeConfigurations = {
      "williamj@little" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          nvf.homeManagerModules.default
          ./home-manager/williamj
        ];
      };

      "williamj@emperor" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          nvf.homeManagerModules.default
          ./home-manager/williamj
        ];
      };
    };
  };
}
