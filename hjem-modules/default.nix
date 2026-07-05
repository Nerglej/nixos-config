{ inputs, ... }: {
  flake.nixosModules.wil-hjem = {
    hjem.specialArgs = { inherit inputs; };

    hjem.extraModules = [
      inputs.hjem-rum.hjemModules.default
      inputs.noctalia.hjemModules.default

      ./bemenu.nix
      ./claude.nix
      ./cursor.nix
      ./fonts.nix
      ./git.nix
      ./gpg.nix
      ./icons.nix
      ./imv.nix
      ./mpd.nix
      ./noctalia.nix
      ./password-store.nix
      ./rmpc.nix
      ./screenshots.nix
      ./shells.nix
      ./terminal.nix
      ./thunderbird.nix
      ./wallpapers.nix
      ./xdg.nix
      ./zellij.nix
    ];
  };
}
