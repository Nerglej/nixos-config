{
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
