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
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "CommitMono"
      ];
    })
  ];

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

  xdg.enable = true;
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  # NEVER CHANGE THIS. IT DOESN'T MATTER WHEN UPGRADING TO ANOTHER VERSION.
  home.stateVersion = "24.11";
}
