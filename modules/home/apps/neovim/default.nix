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
    lua-language-server
    nil

    rust-analyzer
    csharp-ls

    # eslint (js and ts), css, html markdown and json
    vscode-langservers-extracted    
  ];

  home.file."./.config/nvim/" = {
    source = ./config;
    recursive = true;
  };
}
