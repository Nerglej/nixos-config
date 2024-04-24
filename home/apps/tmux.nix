{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    historyLimit = 10000;
    extraConfig = ''
    '';
  };
}
