{ inputs, ... }: {
  flake.nixosModules.wil-hjem = {
    hjem.extraModules = [
      inputs.hjem-rum.hjemModules.default

      ./bemenu.nix
      ./git.nix
      ./password-store.nix
      ./shells.nix
      ./terminal.nix
      ./zellij.nix
    ];
  };
}
