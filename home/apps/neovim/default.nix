{ config, lib, pkgs, userSettings, inputs, ... }:

{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
    ];
    extraPackages = with pkgs; [
      gcc
    ];
    extraConfig = ":luafile ~/.config/nvim/init.lua";
  };

  home.packages = with pkgs; [
    # LSP's
    rust-analyzer
    lua-language-server
    nil
  ];

  home.file."./.config/nvim/" = {
    source = ./config;
    recursive = true;
  };
}
