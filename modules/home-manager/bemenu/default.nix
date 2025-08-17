_: {
  programs = {
    bemenu = {
      enable = true;
      settings = {
        line-height = 28;
        prompt = "open";
        ignorecase = true;
        width-factor = 0.2;
        center = true;
        vim-normal-mode = true;
        vim-esc-exits = true;
        no-cursor = true;

        border-radius = 8;
      };
    };
  };

  home.file.".config/scripts" = {
    source = ./scripts;
    recursive = true;
  };

  home.sessionPath = ["$HOME/.config/scripts"];
}
