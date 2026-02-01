{
  flake.homeModules.direnv = {
    programs.direnv = {
      enable = true;
      silent = false;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };
  };
}
