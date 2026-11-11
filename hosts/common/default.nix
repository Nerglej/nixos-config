{
  inputs,
  lib,
  ...
}:
{
  flake.nixosModules.commonModule =
    { pkgs, ... }:
    {
      nixpkgs.overlays = [
        inputs.self.overlays.unstable-packages
        inputs.nur.overlays.default
      ];

      nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          # custom apps
          "steam"
          "steam-unwrapped"
          "spotify"
          "zoom"

          # HP Printers
          "hplip"

          # required for nvidia driver
          "nvidia-x11"
          "nvidia-settings"

          # extensions
          "dashlane"
        ];

      nix = {
        package = pkgs.nixVersions.stable;
        settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
        settings.trusted-users = [
          "root"
          "@wheel"
        ];
        channel.enable = false;
      };

      imports = [
        inputs.hjem.nixosModules.default
        inputs.self.nixosModules.wil-hjem
      ];

      environment.systemPackages = with pkgs; [
        neovim
        git
        at
        wget
        curl
        gzip
        zip
        unzip
        ripgrep
        wl-clipboard
        podman-compose

        pcmanfm
        shared-mime-info
      ];

      # Use zsh as default shell
      users.defaultUserShell = pkgs.zsh;

      programs.zsh = {
        enable = true;
        syntaxHighlighting.enable = true;

        enableCompletion = true;
        # Manually call compinit in user .zshrc
        enableGlobalCompInit = false;

        histFile = "$HOME/.cache/zsh/history";
        histSize = 10000;
      };

      programs.ssh.startAgent = true;

      programs.thunar = {
        enable = true;
        plugins = with pkgs; [
          thunar-volman
          thunar-media-tags-plugin
          thunar-archive-plugin
        ];
      };
      # For automatic thunar device disc:
      services.gvfs.enable = true;

      programs.xfconf.enable = true;
      programs.dconf.enable = true;

      programs.virt-manager.enable = true;

      services.atd.enable = true;
      services.timesyncd.enable = true;
      services.blueman.enable = true;

      services.openssh = {
        enable = true;
        ports = [ 22 ];
        openFirewall = true;
        settings = {
          PasswordAuthentication = false;
          X11Forwarding = true;
          PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
        };
      };

      fonts = {
        enableDefaultPackages = true;
        fontDir.enable = true;
        packages = with pkgs; [
          # Mono
          nerd-fonts.jetbrains-mono
          nerd-fonts.commit-mono

          # Nice ones
          dejavu_fonts
          noto-fonts-color-emoji
        ];
      };

      virtualisation = {
        libvirtd.enable = true;
        spiceUSBRedirection.enable = true;

        containers.enable = true;
        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };

        oci-containers.backend = "podman";
      };
    };
}
