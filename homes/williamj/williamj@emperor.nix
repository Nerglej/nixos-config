{
  flake.homeConfigurations."williamj@emperor" =
    { inputs, ... }:
    {
      imports = [
        inputs.self.homeModules.hyprland
        inputs.self.homeConfigurations.williamj
      ];
    };
}
