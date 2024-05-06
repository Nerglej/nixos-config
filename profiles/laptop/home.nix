{ systemSettings, userSettings, ... }:

{
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  programs.home-manager.enable = true;

  imports = [
    ../../home/apps/zellij
    ../../home/apps/git
    ../../home/apps/neovim
    ../../home/apps/firefox
    ../../home/apps/chrome
    ../../home/apps/zoom
    ../../home/apps/discord
    ../../home/config/shell.nix
  ];

  home.stateVersion = systemSettings.stateVersion;

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
