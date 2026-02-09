{
  flake.homeConfigurations."williamj" =
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
        inputs.self.homeModules.nvf
        inputs.self.homeModules.password-store
        inputs.self.homeModules.rmpc
        inputs.self.homeModules.zellij
        inputs.self.homeModules.zsh
      ];

      home = {
        username = "williamj";
        shellAliases = {
          ll = "ls -l";
        };
        homeDirectory = "/home/williamj";
        sessionVariables = {
          EDITOR = "nvim";
          TERMINAL = "foot";
          BROWSER = "librewolf";
          # SPAWNEDITOR = userSettings.spawnEditor;
          MANPAGER = "nvim +Man!";
        };

        # Custom programs and apps
        packages = with pkgs; [
          # Apps
          jq
          nushell
          vesktop
          libreoffice
          prismlauncher # Minecraft
          devenv

          pandoc
          texlive.combined.scheme-small

          unstable.claude-code
          unstable.gemini-cli
          unstable.opencode

          # Unfree apps
          spotify
          zoom-us

          # Fonts
          nerd-fonts.jetbrains-mono
          nerd-fonts.commit-mono
        ];
      };

      wij.password-store.enable = true;

      wij.firefox.enable = true;
      wij.librewolf.enable = true;
      wij.librewolf.mimeAppDefault = true;

      wij.git = {
        enable = true;
        name = "William Jelgren";
        email = "william@jelgren.dk";
      };

      stylix = {
        targets = {
          nvf = {
            enable = false;
            plugin = "mini-base16";
            transparentBackground = true;
          };
          waybar.addCss = false;
        };
      };

      gtk.enable = true;

      # Used to properly updated the local fonts folders
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
