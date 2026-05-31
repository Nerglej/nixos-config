let
  username = "williamj";
in
{
  flake.homeModules.${username} =
    { inputs, pkgs, ... }:
    {
      imports = [
        inputs.self.homeModules.bemenu
        inputs.self.homeModules.claude-code
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

      home.file."Pictures/Wallpapers" = {
        source = ../media/Wallpapers;
        recursive = true;
      };

      home = {
        inherit username;

        # The most important aliases ever
        shellAliases = {
          "l" = "ls -lah";
          "la" = "ls -lAh";
          "ll" = "ls -lh";
          "ls" = "ls -G";
          "lsa" = "ls -lah";
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
          vesktop
          # fluffychat
          libreoffice
          prismlauncher # Minecraft
          inkscape
          chromium

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

      wij.password-store.enable = true;

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

      wij.git = {
        enable = true;
        name = "William Jelgren";
        email = "william@jelgren.dk";
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
