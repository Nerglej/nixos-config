{
  inputs,
  outputs,
  lib,
  config,
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
    outputs.homeManagerModules.lan-mouse
    outputs.homeManagerModules.nvf
    outputs.homeManagerModules.zellij
    outputs.homeManagerModules.zsh

    ./hyprland.nix
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
      rmpc

      # Fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.commit-mono
    ];
  };

  services.mpd = {
    enable = true;
    musicDirectory = "~/Music";
  };

  fonts.fontconfig.enable = true;

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

    firefox.enable = true;
    thunderbird = {
      enable = true;
      profiles = {};
    };
    rmpc.enable = true;

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
