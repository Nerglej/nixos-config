{ userSettings, ... }:

{
  home.username = userSettings.username;
  home.homeDirectory = "/home/${ userSettings.username }";

  programs.home-manager.enable = true;

  imports = [
    ../../modules/home/apps/zellij
    ../../modules/home/apps/git
    ../../modules/home/apps/ripgrep
    ../../modules/home/apps/neovim

    ../../modules/home/apps/firefox
    ../../modules/home/apps/chrome
    ../../modules/home/apps/zoom
    ../../modules/home/apps/discord
    ../../modules/home/config/shell.nix
  ];

  home.stateVersion = "23.11";

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
