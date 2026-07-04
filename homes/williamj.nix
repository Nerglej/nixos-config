let
  username = "williamj";
in
{
  flake.homeModules.${username} =
    { inputs, pkgs, ... }:
    {
      imports = [
        inputs.self.homeModules.gpg
        inputs.self.homeModules.librewolf
      ];

      home.file."Pictures/Wallpapers" = {
        source = ../media/wallpapers;
        recursive = true;
      };

      home = {
        inherit username;

        homeDirectory = "/home/${username}";
      };

      programs.firefox.enable = true;

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

      services.blueman-applet.enable = true;

      programs = {
        home-manager.enable = true;
        imv.enable = true;

        thunderbird = {
          enable = true;
          profiles = { };
        };
      };

      # NEVER CHANGE THIS. IT DOESN'T MATTER WHEN UPGRADING TO ANOTHER VERSION.
      home.stateVersion = "24.11";
    };
}
