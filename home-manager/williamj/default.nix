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
    shellAliases = {
      ll = "ls -l";
    };
  };
in {
  imports = [
    # outputs.homeManagerModules.neovim
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

  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";
  home.shellAliases = userSettings.shellAliases;
  home.sessionVariables = {
    EDITOR = userSettings.editor;
    TERMINAL = userSettings.terminal;
    # SPAWNEDITOR = userSettings.spawnEditor;
    # BROWSER = userSettings.browser;
  };

  # Custom programs and apps
  home.packages = with pkgs; [
    zoom-us
    discord
    google-chrome
    ripgrep
    libreoffice

    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.commit-mono
  ];

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;
  programs.foot = {
    enable = true;
    settings.main = {
      font = "CommitMono Nerd Font:size=10";
    };
  };
  programs.git = {
    enable = true;
    userName = userSettings.name;
    userEmail = userSettings.email;

    extraConfig = {
      init.defaultBranch = "main";

      safe.directory = "/home/" + userSettings.username + "/.dotfiles";

      credential.helper = "${pkgs.git.override {withLibsecret = true;}}/bin/git-credential-libsecret";
    };
  };
  programs.firefox.enable = true;
  programs.thunderbird = {
    enable = true;
    profiles = {};
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
