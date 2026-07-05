{ inputs, ... }: {
  flake.nixosModules.wil-hjem = {
    hjem.extraModules = [
      inputs.hjem-rum.hjemModules.default

      ./bemenu.nix
      ./claude.nix
      ./cursor.nix
      ./fonts.nix
      ./git.nix
      ./gpg.nix
      ./icons.nix
      ./imv.nix
      ./mpd.nix
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
