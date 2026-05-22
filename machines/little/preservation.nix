{
  preservation = {
    enable = false;

    preserveAt."/persistent" = {
      files = [
        {
          file = "/etc/machine-id";
          initrd = true;
        }
      ];

      directories = [
        "/etc/nixos"
        "/var/lib/bluetooth"
        {
          directory = "/var/lib/nixos";
          initrd = true;
        }
      ];

      # Preserve user files
      users.williamj = {
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
          ".histfile"
          ".zsh_history"
        ];
      };
    };
  };
}
