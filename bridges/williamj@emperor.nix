{ inputs, ... }:
let
  username = "williamj";
  hostname = "emperor";
in
{
  flake.nixosModules."${username}@${hostname}" =
    { pkgs, ... }:
    {
      hjem = {
        users.${username} = {
          enable = true;
          directory = "/home/${username}";
          user = username;

          wil.terminal.enable = true;
          wil.shell.enable = true;
          wil.git = {
            enable = true;
            name = "William Jelgren";
            email = "william@jelgren.dk";
          };
          wil.bemenu.enable = true;
          wil.password-store.enable = true;
          wil.zellij.enable = true;

          wil.rmpc.enable = true;
          wil.claude-code.enable = true;
        };

        clobberByDefault = true;
      };

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

        files = [ ];
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

      wij.compositor.monitors =
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
