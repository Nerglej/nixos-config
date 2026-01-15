{
  inputs,
  config,
  pkgs,
  ...
}:
let
  inherit (inputs) self;

  systemSettings = {
    hostname = "emperor";
    timezone = "Europe/Copenhagen";
    locale = "en_US.UTF-8";
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ../common

    inputs.nixos-ddcci-nvidia.nixosModules.default

    self.nixosModules.sddm
    self.nixosModules.hardware
  ];

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

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      withUWSM = true;
    };
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
    ollama = {
      enable = true;
      package = pkgs.unstable.ollama-cuda;
      # Use Nvidia thingies I pay for
      acceleration = "cuda";
      loadModels = [ "deepseek-coder-v2:16b" ];
    };
  };

  environment.systemPackages = with pkgs; [
    # manages physical display stuff
    ddcutil
  ];

  modules.sddm.enable = true;
  modules.system = {
    hardware.printing.enable = true;
    hardware.power.enable = false;
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
    nvidia = {
      open = true;
    };
    i2c.enable = true;
    ddcci.enable = true;
  };

  nix.settings = {
    substituters = [ "https://cache.nixos-cuda.org" ];
    trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
  };

  # Pipewire realtime security
  security.rtkit.enable = true;

  system.stateVersion = "24.11";
}
