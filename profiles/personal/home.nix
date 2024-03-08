{ config, pkgs, systemSettings, userSettings, inputs, ... }:

{
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  programs.home-manager.enable = true;

  imports = [
    ../../user/apps/git.nix
    ../../user/apps/gh.nix
    ../../user/apps/neovim.nix
    ../../user/config/shell.nix
    ../../user/apps/browser/firefox.nix
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
