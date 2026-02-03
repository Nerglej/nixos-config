{
  flake.homeConfigurations."williamj@emperor" =
    { inputs, lib, ... }:
    {
      imports = [
        inputs.self.homeModules.compositor
        inputs.self.homeModules.mangowc
        inputs.self.homeConfigurations.williamj
      ];

      wij.compositor.monitors = rec {
        "DP-1" = {
          width = 3840;
          height = 2160;
          refresh = 144;
          x = 0.0;
          y = 0.0;
          scale = 1.3333;
        };
        "DP-2" = rec {
          width = 1920;
          height = 1080;
          refresh = 240;
          x = DP-1.width / DP-1.scale;
          y = DP-1.height / DP-1.scale / 2 - height / 2;
          scale = 1.0;
        };
      };
    };
}
