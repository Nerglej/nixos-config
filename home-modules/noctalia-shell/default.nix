{
  flake.homeModules.noctalia-shell =
    { inputs, ... }:
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia-shell = {
        enable = true;
        systemd.enable = true;

        settings = {
          colorSchemes.predefinedScheme = "Gruvbox";

          location = {
            name = "Denmark";
            monthBeforeDay = false;
          };

          bar = {
            widgets = {
              left = [
                { id = "Clock"; }
                { id = "SystemMonitor"; }
                { id = "ActiveWindow"; }
              ];
              center = [
                {
                  id = "Workspace";
                  labelMode = "none";
                  hideUnoccupied = false;
                }

              ];
              right = [
                { id = "MediaMini"; }
                { id = "Tray"; }
                { id = "NotificationHistory"; }
                { id = "Battery"; }
                { id = "Volume"; }
                { id = "Brightness"; }
                { id = "ControlCenter"; }
              ];
            };
          };
          wallpaper = {
            enabled = true;
            directory = "~/Pictures/Wallpapers";
            recursiveSearch = true;
            setWallpaperOnAllMonitors = true;
            transitionDuration = 1000;
          };
          sessionMenu = {
            enableCountdown = true;
            countdownDuration = 5000;
            powerOptions = [
              {
                action = "lock";
                enabled = true;
              }
              {
                action = "suspend";
                enabled = false;
              }
              {
                action = "hibernate";
                enabled = false;
              }
              {
                action = "reboot";
                enabled = true;
              }
              {
                action = "logout";
                enabled = true;
              }
              {
                action = "shutdown";
                enabled = true;
              }
            ];
          };
        };
      };
    };
}
