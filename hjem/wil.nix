{ inputs, pkgs, ... }: {
  wil = {
    terminal.enable = true;
    shell.enable = true;
    zsh.enable = true;
    git = {
      enable = true;
      name = "William Jelgren";
      email = "william@jelgren.dk";
    };

    # Compositor and co
    noctalia.enable = true;
    bemenu.enable = true;
    screenshots.enable = true;

    wallpapers.enable = true;
    cursor.enable = true;
    fonts.enable = true;
    icons.enable = true;

    # Apps
    zellij.enable = true;
    rmpc.enable = true;
    imv.enable = true;
    password-store.enable = true;
    gpg.enable = true;

    thunderbird.enable = true;
    claude-code.enable = true;

    librewolf = {
      enable = true;
      profiles = {
        wij = {
          id = 0;
          isDefault = true;
          extraExtensions = [ pkgs.nur.repos.rycee.firefox-addons.passff ];
        };
        zealand.id = 1;
      };
    };

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
    vesktop
    libreoffice
    prismlauncher # Minecraft

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
