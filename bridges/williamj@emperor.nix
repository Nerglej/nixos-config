{ inputs, ... }:
{
  flake.nixosModules."williamj@emperor" =
    { pkgs, ... }:
    {
      home-manager.users."williamj" = inputs.self.homeConfigurations."williamj@emperor";

      users.users."williamj" = {
        uid = 1000;
        isNormalUser = true;
        description = "William Jelgren";
        extraGroups = [
          "wheel" # Allows user to run `sudo`
          "networkmanager" # Allows network management
          "libvirtd" # Management of virtual machines
          "video" # Allows access to e.g. webcams
          "input" # Full control over `/dev/input`
        ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEcFiqvHVZuxrbmbE8QKk4qLhrcM3A2sRxVSlGjQVayS williamj@little"
        ];
      };
    };

  flake.homeConfigurations."williamj@emperor" =
    { inputs, lib, ... }:
    {
      imports = [
        inputs.self.homeModules.compositor
        inputs.self.homeModules.mangowc

        inputs.self.homeModules.williamj
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
