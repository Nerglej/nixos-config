{ inputs, ... }:
{
  # NixOS config entrypoint
  flake.nixosConfigurations = {
    "little" = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./little
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users."williamj" = inputs.self.homeConfigurations.williamj;

            extraSpecialArgs = { inherit inputs; };
          };
        }
      ];
    };

    "emperor" = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./emperor
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users."williamj" = inputs.self.homeConfigurations.williamj;

            extraSpecialArgs = { inherit inputs; };
          };
        }
      ];
    };
  };
}
