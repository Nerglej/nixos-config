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
    self.homeModules.firefox
    self.homeModules.foot
    self.homeModules.git
    self.homeModules.gpg
    self.homeModules.nvf
    self.homeModules.password-store
    self.homeModules.rmpc
    self.homeModules.zellij
    self.homeModules.zsh
  ];

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

  wij.foot.enable = true;

  wij.password-store.enable = true;

  wij.firefox.enable = true;
  wij.firefox.mimeAppDefault = true;

  wij.git = {
    enable = true;
    inherit (userSettings) name email;
  };

  wij.shell.zsh.enable = true;
  wij.shell.zellij.enable = true;

  wij.hyprland.enable = true;

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

  # Used to properly updated the local fonts folders
  fonts.fontconfig.enable = true;

  services.blueman-applet.enable = true;

  programs = {
    home-manager.enable = true;
    imv.enable = true;

    thunderbird = {
      enable = true;
      profiles = { };
    };
  };

  xdg = {
    enable = true;
    mimeApps.enable = true;
  };

  # NEVER CHANGE THIS. IT DOESN'T MATTER WHEN UPGRADING TO ANOTHER VERSION.
  home.stateVersion = "24.11";
}
