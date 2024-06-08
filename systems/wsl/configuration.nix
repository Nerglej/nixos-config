{ ... }: 

{
  imports = [
    ../../modules/system/apps/zsh.nix
    ../../modules/system/apps/direnv.nix
  ];

  system.stateVersion = "24.05";
  wsl.enable = true;
}
