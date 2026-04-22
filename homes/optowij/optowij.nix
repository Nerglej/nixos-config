{ self, ... }:
{
  flake.homeConfigurations."optowij" =
    { pkgs, inputs, ... }:
    {
      imports = [
        inputs.self.homeModules.bemenu
        inputs.self.homeModules.direnv
        inputs.self.homeModules.firefox
        inputs.self.homeModules.foot
        inputs.self.homeModules.git
        inputs.self.homeModules.gpg
        inputs.self.homeModules.librewolf
        inputs.self.homeModules.password-store
        inputs.self.homeModules.rmpc
        inputs.self.homeModules.zellij
        inputs.self.homeModules.zsh
      ];

      home = {
        username = "optowij";
        shellAliases = {
          ll = "ls -l";
        };
        homeDirectory = "/home/optowij";
        sessionVariables = {
          EDITOR = "nvim";
          TERMINAL = "foot";
          BROWSER = "librewolf";
          # SPAWNEDITOR = userSettings.spawnEditor;
          MANPAGER = "nvim +Man!";
        };

        # Custom programs and apps
        packages = with pkgs; [
          self.packages.${pkgs.stdenv.hostPlatform.system}.neovim

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

      wij.git = {
        enable = true;
        name = "William Jelgren";
        email = "wij@optoceutics.com";
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
