{ inputs, ... }: {
  flake.nixosModules.wil-hjem = {
    hjem.extraModules = [
      inputs.hjem-rum.hjemModules.default

      ./bemenu.nix
      ./git.nix
      ./shells.nix
      ./terminal.nix
    ];
  };
}
