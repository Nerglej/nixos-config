{ inputs, ... }:
let
  username = "williamj";
  hostname = "little";
in
{
  flake.nixosModules."${username}@${hostname}" =
    { pkgs, ... }:
    {
      home-manager.users.${username} = inputs.self.homeConfigurations."${username}@${hostname}";

      users.users.${username} = {
        uid = 1000;
        isNormalUser = true;
        description = "William Jelgren";
        extraGroups = [
          "wheel" # Allows user to run `sudo`
          "networkmanager" # Allows network management
          "libvirtd" # Management of virtual machines
        ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIElU3Z+2DyeacMQmnMsLoqciaKboKddIwv/LYrWbL2K5 williamj@emperor"
        ];
      };

      preservation.preserveAt."/persistent".users.${username} = {
        directories = [
          ".cache"
          ".config"

          ".gnupg"
          ".librewolf"
          ".mozilla"
          ".claude"
          ".password-store"
          ".ssh"
          ".steam"
          ".thunderbird"

          "Desktop"
          "Documents"
          "Downloads"
          "Music"
          "Pictures"
          "Projects"
          "Videos"
          "Zealand"
        ];

        files = [
          ".claude.json"
        ];
      };
    };

  flake.homeConfigurations."${username}@${hostname}" =
    { inputs, ... }:
    {
      imports = [
        inputs.self.homeModules.compositor
        inputs.self.homeModules.mangowc

        inputs.self.homeModules.williamj
      ];

      wij.compositor.monitors = {
        "eDP-1" = {
          width = 1920;
          height = 1080;
          refresh = 60.0;
          x = 0.0;
          y = 1440.0;
          scale = 1.0;
        };
        "HDMI-A-1" = {
          width = 2560;
          height = 1440;
          refresh = 60.0;
          x = 0.0;
          y = 0.0;
          scale = 1.0;
        };
      };
    };
}
