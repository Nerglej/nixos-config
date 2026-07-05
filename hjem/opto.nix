{ inputs, pkgs, ... }: {
  wil = {
    terminal.enable = true;
    shell.enable = true;
    git = {
      enable = true;
      name = "William Jelgren";
      email = "wij@optoceutics.com";
    };
    bemenu.enable = true;
    zellij.enable = true;

    rmpc.enable = true;
    claude-code.enable = true;

    imv.enable = true;
    icons.enable = true;

    wallpapers.enable = true;
    screenshots.enable = true;

    gpg.enable = true;

    xdg.enable = true;
    xdg.mimeApps.enable = true;
    xdg.mimeApps.defaultApplications = ''
      default-web-browser=librewolf.desktop
      text/html=librewolf.desktop

      x-scheme-handler/about=librewolf.desktop
      x-scheme-handler/http=librewolf.desktop
      x-scheme-handler/https=librewolf.desktop
      x-scheme-handler/unknown=librewolf.desktop
    '';
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
    libreoffice

    firefox
    chromium

    inkscape
    gimp

    # CLI's'n'stuff
    jq
    nushell

    # Corner of shame (unfree)
    spotify
    zoom-us
  ];
}
