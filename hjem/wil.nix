{ inputs, pkgs, ... }: {
  wil = {
    terminal.enable = true;
    shell.enable = true;
    git = {
      enable = true;
      name = "William Jelgren";
      email = "william@jelgren.dk";
    };
    bemenu.enable = true;
    password-store.enable = true;
    zellij.enable = true;

    rmpc.enable = true;
    claude-code.enable = true;

    imv.enable = true;

    wallpapers.enable = true;
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "foot";
    BROWSER = "librewolf";
    MANPAGER = "nvim +Man!";
  };

  packages = with pkgs; [
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.neovim

    # Apps
    vesktop
    libreoffice
    prismlauncher # Minecraft
    chromium

    inkscape
    gimp

    # CLI's'n'stuff
    jq
    nushell

    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.commit-mono

    # Corner of shame (unfree)
    spotify
    zoom-us
  ];
}
