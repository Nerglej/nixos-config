let
  username = "optowij";
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
        shellAliases = {
          ll = "ls -l";
        };
        homeDirectory = "/home/${username}";
        sessionVariables = {
          EDITOR = "nvim";
          TERMINAL = "foot";
          BROWSER = "librewolf";
          # SPAWNEDITOR = userSettings.spawnEditor;
          MANPAGER = "nvim +Man!";
        };

        # Custom programs and apps
        packages = with pkgs; [
          inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.neovim

          # Apps
          chromium
          libreoffice

          # CLI's'n'stuff
          jq
          nushell

          # Fonts
          nerd-fonts.jetbrains-mono
          nerd-fonts.commit-mono

          # Corner of shame (unfree)
          spotify
          zoom-us
        ];
      };

      wij.firefox.enable = true;
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
