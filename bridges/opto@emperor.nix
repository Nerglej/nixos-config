{ inputs, ... }:
let
  username = "opto";
  hostname = "emperor";
in
{
  flake.nixosModules."${username}@${hostname}" =
    { lib, pkgs, ... }:
    {
      users.users.${username} = {
        uid = 1001;
        isNormalUser = true;
        description = "William (Optoceutics)";
        initialHashedPassword = "$y$j9T$9AMC8EtJxaO6yipaFH5jn1$Z3LJQ79j5f6coazx9is2QunZ8swE8Jx5e6acCrAt6N5";
        extraGroups = [
          "networkmanager" # Allows network management
          "libvirtd" # Management of virtual machines
          "adbusers" # ADB access for non-privileged users
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
            monitors =
              let
                dp-1 = {
                  width = 3840;
                  height = 2160;
                  scale = 1.3333;
                };
              in
              [
                {
                  name = "DP-1";
                  width = dp-1.width;
                  height = dp-1.height;
                  refresh = 144.0;
                  x = 0.0;
                  y = 0.0;
                  scale = dp-1.scale;
                }
                rec {
                  name = "DP-2";
                  width = 1920;
                  height = 1080;
                  refresh = 240.0;
                  x = dp-1.width / dp-1.scale;
                  y = dp-1.height / dp-1.scale / 2 - height / 2;
                  scale = 1.0;
                }
              ];
          };
        }
      ];
    };
}
