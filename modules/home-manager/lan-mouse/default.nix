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
                    activate_on_startup = false;
                    ips = ["192.168.68.120"];
                }
                {
                    position = "bottom";
                    hostname = "little";
                    activate_on_startup = true;
                    ips = ["192.168.68.121"];
                }
            ];
            authorized_fingerprints = {
                "d3:8d:44:d9:a8:9e:82:5a:55:95:f3:fd:46:07:ee:7e:9b:57:3f:c1:8d:72:a1:70:23:ce:0a:48:63:94:17:0a" = "Little";
                "df:74:b4:3c:29:3f:d3:23:3d:57:42:c8:07:39:e8:b8:4b:b7:6c:e5:eb:18:bf:fb:29:87:cc:a8:47:bd:d9:66" = "Emperor";
            };
        };
    };
}

