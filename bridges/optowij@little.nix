{ inputs, ... }:
{
  flake.nixosModules."optowij@little" =
    { lib, pkgs, ... }:
    {
      hjem.clobberByDefault = true;
      hjem.users."optowij" = lib.mkMerge [
        {
          enable = true;
          directory = "/home/optowij";
          user = "optowij";
        }

        (import ../hjem/opto.nix { inherit inputs pkgs; })
      ];

      home-manager.users."optowij" = inputs.self.homeConfigurations."optowij@little";

      users.users."optowij" = {
        uid = 1001;
        isNormalUser = true;
        description = "William (Optoceutics)";
        initialHashedPassword = "$6$jgX3WhhNPUW5A371$1u4EI8SW7wIngT5ZxsBw74ITviClPEt59G4ehhK2ZR8Ggak6slWeyn2eeztahUhy8JzyHCRa7y4VztACpk8o20";
        extraGroups = [
          "networkmanager" # Allows network management
          "libvirtd" # Management of virtual machines
        ];
      };
    };

  flake.homeConfigurations."optowij@little" =
    { inputs, pkgs, ... }:
    {
      imports = [
        inputs.self.homeModules.compositor
        inputs.self.homeModules.mangowc

        inputs.self.homeModules.optowij
      ];

      wij.compositor.monitors = [
        {
          name = "eDP-1";
          width = 1920;
          height = 1080;
          refresh = 60.0;
          x = 0.0;
          y = 1440.0;
          scale = 1.0;
        }
        {
          name = "HDMI-A-1";
          width = 2560;
          height = 1440;
          refresh = 60.0;
          x = 0.0;
          y = 0.0;
          scale = 1.0;
        }
        {
          # make = "GIGA-BYTE TECHNOLOGY CO., LTD.";
          model = "Gigabyte M32U";
          width = 2560;
          height = 1440;
          refresh = 120.0;
          x = 0.0;
          y = 0.0;
          scale = 1.0;
        }
      ];
    };
}
