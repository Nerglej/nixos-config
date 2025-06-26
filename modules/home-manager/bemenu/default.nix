{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs = {
    bemenu = {
      enable = true;
      settings = {
        line-height = 28;
        prompt = "open";
        ignorecase = true;
        width-factor = 0.3;
        center = true;
        vim-normal-mode = true;
        vim-esc-exits = true;
      };
    };
  };
}
