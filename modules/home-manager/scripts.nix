{
  home.file.".config/scripts/general" = {
    source = ./scripts;
    recursive = true;
  };

  home.sessionPath = ["$HOME/.config/scripts/general"];
}
