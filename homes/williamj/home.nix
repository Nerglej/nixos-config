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
  ];

  programs.firefox.enable = true;
  programs.thunderbird.enable = true;

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

  programs.zellij = {
    enable = true;
    settings = {};
  };


  imports = [
    ../../modules/home/apps/neovim
  ];

  home.stateVersion = "24.05";

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
