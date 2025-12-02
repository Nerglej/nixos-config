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
    inputs.lan-mouse.homeManagerModules.default
    outputs.homeManagerModules.bemenu
    outputs.homeManagerModules.hyprland
    outputs.homeManagerModules.lan-mouse
    outputs.homeManagerModules.nvf
    outputs.homeManagerModules.zellij
    outputs.homeManagerModules.zsh
  ];

  stylix = {
    targets = {
      nvf = {
        enable = false;
        plugin = "mini-base16";
        transparentBackground = true;
      };
      waybar.addCss = false;
    };
  };

  gtk.enable = true;

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
      alsa-utils
      google-chrome
      libreoffice
      obsidian
      spotify
      beeper
      jq

      pinentry-qt
      # pinentry-curses

      discord

      # Games
      prismlauncher

      # Fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.commit-mono

      unstable.cursor-cli
      unstable.code-cursor
    ];
  };

  fonts.fontconfig.enable = true;

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
      pinentry.package = pkgs.pinentry-qt;
      pinentry.program = "pinentry-qt";
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
      };
    };

    git = {
      enable = true;

      settings = {
        user.name = userSettings.name;
        user.email = userSettings.email;

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

    direnv = {
      enable = true;
      silent = false;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: with exts; [pass-otp]);
      settings = {
        PASSWORD_STORE_DIR = "$HOME/.password-store";
      };
    };

    gpg.enable = true;

    firefox = {
      enable = true;
      package = pkgs.firefox.override {nativeMessagingHosts = [pkgs.passff-host];};
    };

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

  modules.hyprland.enable = true;

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
