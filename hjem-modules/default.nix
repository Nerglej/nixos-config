{ inputs, ... }: {
  flake.nixosModules.wil-hjem = {
    hjem.specialArgs = { inherit inputs; };

    hjem.extraModules = [
      inputs.hjem-rum.hjemModules.default
      inputs.noctalia.hjemModules.default
      inputs.mango.hjemModules.default

      ./bemenu.nix
      ./claude.nix
      ./compositor.nix
      ./cursor.nix
      ./fonts.nix
      ./git.nix
      ./gpg.nix
      ./icons.nix
      ./imv.nix
      ./librewolf.nix
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
      ./zsh.nix
    ];
  };
}
