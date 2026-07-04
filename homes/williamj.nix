let
  username = "williamj";
in
{
  flake.homeModules.${username} =
    { inputs, pkgs, ... }:
    {
      imports = [
        inputs.self.homeModules.firefox
        inputs.self.homeModules.gpg
        inputs.self.homeModules.librewolf
      ];

      home = {
        inherit username;
        homeDirectory = "/home/${username}";
      };

      wij.firefox.enable = true;
      wij.librewolf.enable = true;
      wij.librewolf.mimeAppDefault = true;
      wij.librewolf.profiles = {
        "wij" = {
          id = 0;
          isDefault = true;
          extraExtensions = [ pkgs.nur.repos.rycee.firefox-addons.passff ];
        };
        "zealand" = {
          id = 1;
        };
      };

      stylix.targets = {
        nvf.enable = false;
        waybar.addCss = false;
      };

      gtk.enable = true;

      # Used to properly update the local fonts folders
      fonts.fontconfig.enable = true;

      services.blueman-applet.enable = true;

      programs = {
        home-manager.enable = true;
        imv.enable = true;

        thunderbird = {
          enable = true;
          profiles = { };
        };
      };

      xdg = {
        enable = true;
        mimeApps.enable = true;
      };

      # NEVER CHANGE THIS. IT DOESN'T MATTER WHEN UPGRADING TO ANOTHER VERSION.
      home.stateVersion = "24.11";
    };
}
