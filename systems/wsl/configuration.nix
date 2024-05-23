{ pkgs, lib, ... }: 

{
  imports = [
    ../../modules/system/apps/zsh.nix
    ../../modules/system/apps/direnv.nix
  ];

  system.stateVersion = "23.11";
  wsl.enable = true;
}
