{ inputs, ... }:
let
  username = "williamj";
  hostname = "emperor";
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
          "video" # Allows access to e.g. webcams
          "input" # Full control over `/dev/input`
        ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEcFiqvHVZuxrbmbE8QKk4qLhrcM3A2sRxVSlGjQVayS williamj@little"
        ];
      };

      services.borgbackup.jobs."${username}-${hostname}" =
        let
          home = "/home/${username}";
        in
        {
          user = username;
          paths = [
            "${home}/Desktop"
            "${home}/Documents"
            "${home}/Downloads"
            "${home}/Music"
            "${home}/Pictures"
            "${home}/Public"
            "${home}/Templates"
            "${home}/Videos"

            "${home}/.password-store"
            "${home}/.ssh"
            "${home}/.vim"

            "${home}/.config/projectdirs"
          ];
          exclude = [
            "*/.git"
            "*/node_modules"
          ];

          repo = "/var/lib/borgbackup/${username}";
          encryption.mode = "none";

          startAt = "weekly";
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
          "Public"
          "Templates"
          "Videos"
        ];

        files = [
          ".claude.json"
        ];
      };
    };

  flake.homeConfigurations."${username}@${hostname}" =
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
          refresh = 144.0;
          x = 0.0;
          y = 0.0;
          scale = 1.3333;
        };
        "DP-2" = rec {
          width = 1920;
          height = 1080;
          refresh = 240.0;
          x = DP-1.width / DP-1.scale;
          y = DP-1.height / DP-1.scale / 2 - height / 2;
          scale = 1.0;
        };
      };
    };
}
