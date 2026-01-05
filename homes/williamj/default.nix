{
  inputs,
  pkgs,
  ...
}:
let
  inherit (inputs) self;

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
in
{
  imports = [
    self.homeModules.hyprland

    self.homeModules.bemenu
    self.homeModules.direnv
    self.homeModules.gpg
    self.homeModules.nvf
    self.homeModules.rmpc
    self.homeModules.zellij
    self.homeModules.zsh
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
      spotify
      discord
      obsidian
      zoom-us
      alsa-utils
      google-chrome
      libreoffice

      # CLI
      jq
      nushell

      # Games
      prismlauncher

      # Unstable stuff
      unstable.cursor-cli
      unstable.code-cursor
      unstable.ollama

      # Fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.commit-mono
    ];
  };

  fonts.fontconfig.enable = true;

  services.blueman-applet.enable = true;

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

        credential.helper = "${
          pkgs.git.override {
            withLibsecret = true;
          }
        }/bin/git-credential-libsecret";
      };
    };

    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: with exts; [ pass-otp ]);
      settings = {
        PASSWORD_STORE_DIR = "$HOME/.password-store";
      };
    };

    firefox = {
      enable = true;
      package = pkgs.firefox.override { nativeMessagingHosts = [ pkgs.passff-host ]; };
    };

    thunderbird = {
      enable = true;
      profiles = { };
    };

    imv = {
      enable = true;
    };
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
        "default-web-browser" = [ "firefox.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      };
    };
  };

  # NEVER CHANGE THIS. IT DOESN'T MATTER WHEN UPGRADING TO ANOTHER VERSION.
  home.stateVersion = "24.11";
}
