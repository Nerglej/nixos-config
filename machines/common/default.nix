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

      hjem.extraModules = [
        inputs.hjem-rum.hjemModules.default
        inputs.self.modules.hjem.terminal
        inputs.self.modules.hjem.shell
        inputs.self.modules.hjem.git
        inputs.self.modules.hjem.bemenu
      ];

      environment.systemPackages = with pkgs; [
        home-manager
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

      programs.thunar.enable = true;
      programs.kdeconnect.enable = true;
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
