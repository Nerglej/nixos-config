{
  inputs,
  outputs,
  pkgs,
  ...
}: let
  userSettings = {
    username = "williamj";
    name = "William Jelgren";
    email = "william@jelgren.dk";
    editor = "nvim";
    terminal = "foot";
    browser = "firefox";
    shellAliases = {
      ll = "ls -l";
    };
  };
in {
  imports = [
    inputs.nvf.homeManagerModules.default
    inputs.lan-mouse.homeManagerModules.default
    outputs.homeManagerModules.bemenu
    outputs.homeManagerModules.hyprland
    outputs.homeManagerModules.swaync
    outputs.homeManagerModules.lan-mouse
    outputs.homeManagerModules.nvf
    outputs.homeManagerModules.zellij
    outputs.homeManagerModules.zsh
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    inherit (userSettings) username;
    inherit (userSettings) shellAliases;

    homeDirectory = "/home/${userSettings.username}";
    sessionVariables = {
      EDITOR = userSettings.editor;
      TERMINAL = userSettings.terminal;
      BROWSER = userSettings.browser;
      # SPAWNEDITOR = userSettings.spawnEditor;
      MANPAGER = "${userSettings.editor} +Man!";
    };

    # Custom programs and apps
    packages = with pkgs; [
      # Apps
      zoom-us
      discord
      google-chrome
      libreoffice
      obsidian
      spotify
      beeper

      pinentry-curses

      # Games
      prismlauncher

      # Fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.commit-mono

      # Cursor
      graphite-cursors
      bibata-cursors
    ];
  };

  fonts.fontconfig.enable = true;

  home.pointerCursor = {
    enable = true;
    hyprcursor.enable = true;
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  services = {
    mpd = {
      enable = true;
      musicDirectory = "~/Music";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "PipeWire Output"
        }
      '';
    };

    gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      pinentry.package = pkgs.pinentry-curses;
      pinentry.program = "pinentry-curses";
    };

    blueman-applet.enable = true;
  };

  programs = {
    home-manager.enable = true;

    foot = {
      enable = true;
      settings = {
        main = {
          font = "CommitMono Nerd Font:size=12";
        };

        colors.alpha = 0.8;
      };
    };

    git = {
      enable = true;
      userName = userSettings.name;
      userEmail =
        userSettings.email;

      extraConfig = {
        init.defaultBranch = "main";

        safe.directory =
          "/home/"
          + userSettings.username
          + "/.dotfiles";

        credential.helper = "${pkgs.git.override {
          withLibsecret =
            true;
        }}/bin/git-credential-libsecret";
      };
    };

    password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_DIR = "$HOME/.password-store";
      };
    };
    gpg.enable = true;

    firefox.enable = true;
    thunderbird = {
      enable = true;
      profiles = {};
    };

    rmpc = {
      enable = true;
      config = builtins.readFile ./rmpc.ron;
    };

    imv = {
      enable = true;
    };
  };

  home.file.".config/rmpc/themes/theme.ron" = {
    source = ./rmpc_theme.ron;
  };

  modules.home.shell = {
    zsh.enable = true;
    zellij.enable = true;
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "default-web-browser" = ["firefox.desktop"];
        "text/html" = ["firefox.desktop"];
        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
        "x-scheme-handler/about" = ["firefox.desktop"];
        "x-scheme-handler/unknown" = ["firefox.desktop"];
      };
    };
  };

  # NEVER CHANGE THIS. IT DOESN'T MATTER WHEN UPGRADING TO ANOTHER VERSION.
  home.stateVersion = "24.11";
}
