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
    };
  };
}
