{
  description = "Williams NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix/release-25.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    alejandra.url = "github:kamadorueda/alejandra/3.1.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    nvf.url = "github:notashelf/nvf";

    hyprland.url = "github:hyprwm/Hyprland";

    split-monitor-workspaces.url = "github:Duckonaut/split-monitor-workspaces";
    split-monitor-workspaces.inputs.hyprland.follows = "hyprland";

    nixos-ddcci-nvidia.url = "github:poogas/nixos-ddcci-nvidia";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      alejandra,
      ...
    }@inputs:
    let
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
    in
    {
      # Formatter for nix files
      formatter = forAllSystems (system: alejandra.defaultPackage.${system});

      overlays = import ./overlays { inherit inputs; };

      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      # NixOS config entrypoint
      nixosConfigurations = {
        "little" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./machines/little
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users."williamj" = import ./homes/williamj;

                extraSpecialArgs = { inherit inputs outputs; };
              };
            }
          ];
        };

        "emperor" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./machines/emperor
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users."williamj" = import ./homes/williamj;

                extraSpecialArgs = { inherit inputs outputs; };
              };
            }
          ];
        };
      };
    };
}
