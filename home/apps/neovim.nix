{ config, pkgs, userSettings, inputs, ... }:

{
  # imports = [
  #   inputs.nixvim.homeManagerModules.nixvim
  # ];

  programs.neovim = {
    enable = true;
    extraLuaConfig = lib.fileContents ./neovim/init.lua;
  };

 # programs.nixvim = {
 #   enable = true;

 #   colorschemes.gruvbox.enable = true;
 #   plugins = {
 #     lightline.enable = true;

 #     telescope = {
 #       enable = true;

 #       extensions = {
 #         fzf-native.enable = true;
 #         file_browser.enable = true;
 #       };
 #     };

 #     treesitter.enable = true;
 #   };
 #   
 #   options = {
 #     relativenumber = true;
 #     number = true;

 #     expandtab = true;
 #     shiftwidth = 2;
 #     smartindent = true;
 #     tabstop = 2;
 #   };

 #   globals = {
 #     mapleader = " ";
 #   };
 # };

  xdg.configFile.nvim = {
    source = "./neovim/init.lua";
    recursive = true;
  };
}
