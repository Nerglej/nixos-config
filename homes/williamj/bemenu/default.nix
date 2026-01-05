{ pkgs, ... }:
{
  programs = {
    bemenu = {
      enable = true;
      package = pkgs.bemenu;
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

  home.packages = with pkgs; [
    jq
    bemenu

    # Stuff that other parts of the config sets up automatically
    # pipewire
    # notify-send
    # systemd
    # zellij
  ];

  home.file.".config/scripts/bemenu" = {
    source = ./scripts;
    recursive = true;
  };

  home.sessionPath = [ "$HOME/.config/scripts/bemenu" ];
}
