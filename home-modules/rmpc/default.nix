{
  flake.homeModules.rmpc = {
    programs.rmpc = {
      enable = true;
      config = builtins.readFile ./rmpc.ron;
    };

    services.mpd = {
      enable = true;
      musicDirectory = "~/Music";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "PipeWire Output"
        }
      '';
    };

    home.file.".config/rmpc/themes/theme.ron" = {
      source = ./rmpc_theme.ron;
    };
  };
}
