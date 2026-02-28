{
  flake.homeModules.mangowc =
    {
      inputs,
      pkgs,
      lib,
      config,
      ...
    }:
    let
      mangoMonitors = lib.mapAttrsToList (
        name: value:
        "monitorrule=name:${
          if value.name or null != null then value.name else name
        },width:${toString value.width},height:${toString value.height},refresh:${toString value.refresh},x:${toString value.x},y:${toString value.y},scale:${toString value.scale},vrr=${
          if value.enableVariableRefreshRate then "1" else "0"
        }"
      ) config.wij.compositor.monitors;
    in
    {
      imports = [
        inputs.mango.hmModules.mango
        inputs.self.homeModules.noctalia-shell
        inputs.self.homeModules.screenshot-scripts
      ];

      config = {
        wayland.windowManager.mango = {
          enable = true;
          autostart_sh = builtins.readFile ./autostart.sh;
          settings = builtins.readFile ./config.conf + builtins.concatStringsSep "\n" mangoMonitors;
        };

        home.packages = with pkgs; [
          wlr-randr
          brightnessctl
          playerctl
          libnotify
        ];
      };
    };
}
