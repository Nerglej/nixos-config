{
  flake.homeConfigurations."williamj@little" =
    { inputs, ... }:
    {
      imports = [
        inputs.self.homeModules.mangowc
        inputs.self.homeConfigurations.williamj
      ];
    };
}
