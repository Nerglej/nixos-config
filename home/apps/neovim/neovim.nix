{ config, lib, pkgs, userSettings, inputs, ... }:

{
  programs.neovim = {
    enable = true;
  };
  
  # xdg.configFile.nvim = {
  #   source = ./config;
  # };

  # xdg.configFile.nvim = {
  #   source = builtins.fetchGit {
  #     url = "https://github.com/Nerglej/neovim-config"
  #   };
  # };
}
