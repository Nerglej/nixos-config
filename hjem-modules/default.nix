{ inputs, ... }: {
  flake.nixosModules.wil-hjem = {
    hjem.extraModules = [
      inputs.hjem-rum.hjemModules.default

      ./bemenu.nix
      ./claude.nix
      ./git.nix
      ./imv.nix
      ./mpd.nix
      ./password-store.nix
      ./rmpc.nix
      ./shells.nix
      ./terminal.nix
      ./wallpapers.nix
      ./zellij.nix
    ];
  };
}
