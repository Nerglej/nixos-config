{ userSettings, pkgs, ... }:

{
  home.username = userSettings.username;
  home.homeDirectory = "/home/${ userSettings.username }";
  home.shellAliases = userSettings.shellAliases;

  programs.home-manager.enable = true;

  # Custom programs and apps
  home.packages = with pkgs; [
    git
    zoom-us
    discord
    google-chrome
    ripgrep
    libreoffice

    # Fonts
    (nerdfonts.override { fonts = [ "JetBrainsMono" "CommitMono" ]; })

  ];

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

      credential.helper = "${
        pkgs.git.override { withLibsecret = true; }  
      }/bin/git-credential-libsecret";
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

  modules.home.apps = {
    neovim.enable = true;
  };


  imports = [
    ../../modules/home
  ];

  home.stateVersion = "24.11";

  xdg.enable = true;
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  home.sessionVariables = {
    EDITOR = userSettings.editor;
    TERMINAL = userSettings.terminal;
    # SPAWNEDITOR = userSettings.spawnEditor;
    # BROWSER = userSettings.browser;
  };
}
