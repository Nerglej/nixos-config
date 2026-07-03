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
      inputs.preservation.nixosModules.default
      inputs.home-manager.nixosModules.home-manager

      inputs.nixos-ddcci-nvidia.nixosModules.default

      inputs.self.nixosModules.commonModule
      inputs.self.nixosModules.emperorModule

      # inputs.self.nixosModules.sddm-astronaut
      # inputs.self.nixosModules.greetd-tuigreet
      inputs.self.nixosModules.ly

      inputs.self.nixosModules.printing
      inputs.self.nixosModules.mangowc
      inputs.self.nixosModules.stylix

      inputs.self.nixosModules."williamj@emperor"

      ./hardware-configuration.nix
      ./preservation.nix
    ];
  };

  flake.nixosModules.emperorModule =
    { pkgs, config, ... }:
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

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

      # Enable pipewire for sound
      services.pipewire = {
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

      services.flatpak.enable = true;

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
        nvidia.modesetting.enable = true;

        i2c.enable = true;
        ddcci.enable = true;
      };

      services.xserver.videoDrivers = [ "nvidia" ];

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
