{ config, pkgs, systemSettings, userSettings, inputs, ... }:

{
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  programs.home-manager.enable = true;

  imports = [
    ../../home/apps/git.nix
    ../../home/apps/gh.nix
    ../../home/apps/neovim.nix
    ../../home/apps/browser/firefox.nix
    ../../home/config/shell.nix
  ];

  home.stateVersion = systemSettings.stateVersion;

  home.packages = with pkgs; [
    git
  ];

  xdg.enable = true;
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  home.sessionVariables = {
    EDITOR = userSettings.editor;
    # SPAWNEDITOR = userSettings.spawnEditor;
    # TERM = userSettings.term;
    # BROWSER = userSettings.browser;
  };
}
