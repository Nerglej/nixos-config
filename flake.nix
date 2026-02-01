{
  description = "Williams NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    nur.inputs.flake-parts.follows = "flake-parts";

    stylix.url = "github:nix-community/stylix/release-25.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.flake-parts.follows = "flake-parts";
    stylix.inputs.nur.follows = "nur";

    alejandra.url = "github:kamadorueda/alejandra/3.1.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
    nvf.inputs.flake-parts.follows = "flake-parts";

    hyprland.url = "github:hyprwm/Hyprland";

    mango.url = "github:DreamMaoMao/mango";
    mango.inputs.nixpkgs.follows = "nixpkgs";
    mango.inputs.flake-parts.follows = "flake-parts";

    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";

    split-monitor-workspaces.url = "github:Duckonaut/split-monitor-workspaces";
    split-monitor-workspaces.inputs.hyprland.follows = "hyprland";

    nixos-ddcci-nvidia.url = "github:poogas/nixos-ddcci-nvidia";
    nixos-ddcci-nvidia.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      ...
    }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } ({
      imports = [
        inputs.home-manager.flakeModules.home-manager

        (inputs.import-tree ./machines)
        (inputs.import-tree ./homes)

        (inputs.import-tree ./nixos-modules)
        (inputs.import-tree ./home-modules)
      ];

      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        # "aarch64-darwin" # Not supported by alejandra for some reason
        "i686-linux"
      ];

      perSystem =
        { lib, system, ... }:
        {
          # Formatter for nix files
          formatter = inputs.alejandra.defaultPackage."${system}";

          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = lib.attrValues self.overlays;
            config.allowUnfree = true;
          };
        };

      flake = {
        overlays = import ./overlays { inherit inputs; };
      };
    });
}
