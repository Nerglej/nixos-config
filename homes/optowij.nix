let
  username = "optowij";
in
{
  flake.homeModules.${username} =
    { inputs, pkgs, ... }:
    {
      imports = [
        inputs.self.homeModules.gpg
        inputs.self.homeModules.librewolf
      ];

      home = {
        inherit username;
        homeDirectory = "/home/${username}";
      };

      programs.firefox.enable = true;

      wij.librewolf.enable = true;
      wij.librewolf.mimeAppDefault = true;
      wij.librewolf.profiles = {
        "optoceutics" = {
          id = 0;
          isDefault = true;
          extraExtensions = [ pkgs.nur.repos.rycee.firefox-addons.dashlane ];
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
        thunderbird = {
          enable = true;
          profiles = { };
        };
      };

      # NEVER CHANGE THIS. IT DOESN'T MATTER WHEN UPGRADING TO ANOTHER VERSION.
      home.stateVersion = "24.11";
    };
}
