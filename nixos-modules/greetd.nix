{
  flake.nixosModules.noctalia-greeter =
    {
      inputs,
      config,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.noctalia-greeter.nixosModules.default
      ];

      programs.noctalia-greeter = {
        enable = true;
        passwordless-sync-users = [ "williamj" ];
        settings = {
          cursor = {
            theme = "Bibata-Modern-Classic";
            size = 24;
            path = "${pkgs.bibata-cursors}/share/icons";
          };
        };
      };

      security.polkit = {
        enable = true;
        extraConfig = ''
          polkit.addRule(function(action, subject) {
            var allowedUsers = ["williamj"];

            if (action.id == "org.noctalia.greeter.sync-appearance" &&
                action.lookup("program") == "${config.programs.noctalia-greeter.package}/bin/noctalia-greeter-apply-appearance" &&
                action.lookup("user") == "root" &&
                subject.local && subject.active &&
                allowedUsers.indexOf(subject.user) >= 0) {
              return polkit.Result.YES;
            }
          });
        '';
      };
    };

  flake.nixosModules.greetd-tuigreet =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      services.greetd = {
        enable = true;
        useTextGreeter = true;
        settings = {
          default_session = {
            command = lib.strings.join " " [
              "${pkgs.tuigreet}/bin/tuigreet"
              "--greeting 'hello, nerd, this is ${config.networking.hostName}'"
              "--user-menu"
              "--time"
              "--remember"
              "--remember-user-session"
              "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
              "--xsessions ${config.services.displayManager.sessionData.desktops}/share/xsessions"
            ];
            user = "greeter";
          };
        };
      };
    };
}
