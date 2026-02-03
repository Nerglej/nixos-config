{
  inputs,
  ...
}:
let
  systemSettings = {
    hostname = "emperor";
    timezone = "Europe/Copenhagen";
    locale = "en_US.UTF-8";
  };
in
{
  flake.nixosConfigurations."emperor" = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };

    modules = [
      ./_hardware-configuration.nix

      inputs.self.nixosModules.commonModule
      inputs.self.nixosModules.emperorModule

      inputs.self.nixosModules.sddm-astronaut
      inputs.self.nixosModules.printing
      inputs.self.nixosModules.hyprland
      inputs.self.nixosModules.stylix

      inputs.home-manager.nixosModules.home-manager
      inputs.nixos-ddcci-nvidia.nixosModules.default
    ];
  };

  flake.nixosModules.emperorModule =
    { pkgs, config, ... }:
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users."williamj" = inputs.self.homeConfigurations."williamj@emperor";

        extraSpecialArgs = { inherit inputs; };
      };

      # Locale
      time.timeZone = systemSettings.timezone;
      i18n.defaultLocale = systemSettings.locale;
      console.keyMap = "us";

      boot = {
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };

        extraModulePackages = with config.boot.kernelPackages; [ ddcci-driver ];
        kernelModules = [ "ddcci_backlight" ];
      };

      # User account
      users.users = {
        "williamj" = {
          isNormalUser = true;
          description = "William Jelgren";
          extraGroups = [
            "networkmanager"
            "wheel"
            "docker"
            "libvirtd"
            "video"
            "input"
          ];
          uid = 1000;
        };
      };

      # Networking
      networking = {
        hostName = systemSettings.hostname;
        networkmanager.enable = true;

        # Firewall
        firewall = {
          enable = true;
          allowedTCPPorts = [
            57621 # Spotify
          ];
          allowedUDPPorts = [
            5353 # Spotify
          ];
        };
      };

      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };

      services = {
        # Enable the X11 windowing system.
        xserver = {
          enable = true;

          excludePackages = [ pkgs.xterm ];

          # Configure keymap in X11
          xkb.layout = "us";

          # Set nvidia driver
          videoDrivers = [ "nvidia" ];
        };

        # Enable pipewire for sound
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          extraConfig.pipewire = {
            "10-clock-rate" = {
              "context.properties" = {
                "default.clock.rate" = 96000;
                "default.allowed-rates" = [
                  192000
                  96000
                  48000
                  44100
                ];
              };
            };
          };
        };

        flatpak.enable = true;
      };

      hardware = {
        graphics = {
          enable = true;
          # For Steam
          enable32Bit = true;

          # nvidia driver
          extraPackages = [ pkgs.nvidia-vaapi-driver ];
        };

        bluetooth.enable = true;
        bluetooth.powerOnBoot = true;

        # Use open source nvidia drivers
        nvidia.open = true;

        i2c.enable = true;
        ddcci.enable = true;
      };

      environment.systemPackages = with pkgs; [
        unstable.ollama-cuda

        # manages physical display stuff
        ddcutil
      ];

      nix.settings = {
        substituters = [ "https://cache.nixos-cuda.org" ];
        trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
      };

      # Pipewire realtime security
      security.rtkit.enable = true;

      system.stateVersion = "24.11";
    };
}
