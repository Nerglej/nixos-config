{
  lib,
  config,
  pkgs,
  ...
}: {
    programs.lan-mouse = {
        enable = true;
        systemd = true;
        settings = {
            port = 4242;
            # capture_backend = "libei";
            emulation_backend = "libei";
            clients = [
                {
                    position = "top";
                    hostname = "emperor";
                    activate_on_startup = true;
                    ips = ["192.168.68.120"];
                }
            ];
        };
    };
}

