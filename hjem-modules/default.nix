{ inputs, ... }: {
  flake.nixosModules.wil-hjem = {
    hjem.extraModules = [
      inputs.hjem-rum.hjemModules.default

      ./bemenu.nix
      ./claude.nix
      ./cursor.nix
      ./fonts.nix
      ./git.nix
      ./icons.nix
      ./imv.nix
      ./mpd.nix
      ./password-store.nix
      ./rmpc.nix
      ./shells.nix
      ./terminal.nix
      ./wallpapers.nix
      ./xdg.nix
      ./zellij.nix
    ];
  };
}
