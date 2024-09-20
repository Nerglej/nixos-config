{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.home.apps.neovim;
in {
  options.modules.home.apps.neovim = {
    enable = mkEnableOption "Enable NeoVim";
  };

  config = mkIf cfg.enable {
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
  };
}
