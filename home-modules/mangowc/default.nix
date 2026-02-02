{
  flake.homeModules.mangowc =
    { inputs, pkgs, ... }:
    {
      imports = [
        inputs.mango.hmModules.mango
        inputs.self.homeModules.noctalia-shell
      ];

      wayland.windowManager.mango = {
        enable = true;
        settings = builtins.readFile ./config.conf;
      };

      home.packages = with pkgs; [
        brightnessctl
        playerctl
      ];
    };
}
