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

        fb = "#1e1e2e";
        ff = "#cdd6f4";
        nb = "#1e1e2e";
        nf = "#cdd6f4";
        tb = "#1e1e2e";
        hb = "#1e1e2e";
        tf = "#f38ba8";
        hf = "#f9e2af";
        af = "#cdd6f4";
        ab = "#1e1e2e";
      };
    };
  };

  home.file.".config/scripts" = {
    source = ./scripts;
    recursive = true;
  };

  home.sessionPath = ["$HOME/.config/scripts"];
}
