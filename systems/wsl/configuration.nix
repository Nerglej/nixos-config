{ pkgs, lib }: 

{
  imports = [
    ../../modules/system/apps/zsh.nix
    ../../modules/system/apps/direnv.nix
  ];
}
