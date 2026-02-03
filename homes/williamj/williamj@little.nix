{
  flake.homeConfigurations."williamj@little" =
    { inputs, ... }:
    {
      imports = [
        inputs.self.homeModules.mangowc
        inputs.self.homeConfigurations.williamj
      ];

      wij.compositor.monitors = {
        "eDP-1" = {
          width = 1920;
          height = 1080;
          refresh = 60;
          x = 0;
          y = 0;
          scale = 1.0;
        };
      };
    };
}
