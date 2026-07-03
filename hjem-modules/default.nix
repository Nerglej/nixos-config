{ inputs, ... }: {
  flake.nixosModules.wil-hjem = {
    hjem.extraModules = [
      inputs.hjem-rum.hjemModules.default

      ./bemenu.nix
      ./claude.nix
      ./git.nix
      ./mpd.nix
      ./password-store.nix
      ./rmpc.nix
      ./shells.nix
      ./terminal.nix
      ./zellij.nix
    ];
  };
}
