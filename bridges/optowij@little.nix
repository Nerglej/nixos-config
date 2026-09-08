{ inputs, ... }:
let
  username = "optowij";
  hostname = "little";
in
{
  flake.nixosModules."${username}@${hostname}" =
    { lib, pkgs, ... }:
    {
      users.users.${username} = {
        uid = 1001;
        isNormalUser = true;
        description = "William (Optoceutics)";
        initialHashedPassword = "$6$jgX3WhhNPUW5A371$1u4EI8SW7wIngT5ZxsBw74ITviClPEt59G4ehhK2ZR8Ggak6slWeyn2eeztahUhy8JzyHCRa7y4VztACpk8o20";
        extraGroups = [
          "networkmanager" # Allows network management
          "libvirtd" # Management of virtual machines
        ];
      };

      hjem.clobberByDefault = true;
      hjem.users.${username} = lib.mkMerge [
        {
          enable = true;
          directory = "/home/${username}";
          user = username;
        }

        (import ../hjem/opto.nix { inherit inputs pkgs; })

        {
          wil.compositor.mango = {
            enable = true;
            monitors = [
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
      ];
    };
}
