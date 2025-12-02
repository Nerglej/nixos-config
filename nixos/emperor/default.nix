{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: let
  systemSettings = {
    hostname = "emperor";
    timezone = "Europe/Copenhagen";
    locale = "en_US.UTF-8";
  };
in {
  imports = [
    inputs.nixos-ddcci-nvidia.nixosModules.default

    outputs.nixosModules.stylix
    outputs.nixosModules.sddm
    outputs.nixosModules.hardware
    ./hardware-configuration.nix
  ];

  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
    overlays = [outputs.overlays.unstable-packages];
  };

  nix = {
    package = pkgs.nixVersions.stable;
    settings.experimental-features = ["nix-command" "flakes"];
    channel.enable = false;
  };

  # Locale
  time.timeZone = systemSettings.timezone;
  i18n.defaultLocale = systemSettings.locale;

  boot = {
    # Bootloader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    extraModulePackages = with config.boot.kernelPackages; [ddcci-driver];
    kernelModules = ["ddcci_backlight"];
  };

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    graphics = {
      enable = true;
      # For Steam
      enable32Bit = true;

      # nvidia driver
      extraPackages = [pkgs.nvidia-vaapi-driver];
    };

    # Use open source nvidia drivers
    nvidia.open = true;
    i2c.enable = true;
    ddcci.enable = true;
  };

  services = {
    timesyncd.enable = true;

    # Enable the X11 windowing system.
    xserver = {
      enable = true;

      # Configure keymap in X11
      xkb.layout = "us";

      # Set nvidia driver
      videoDrivers = ["nvidia"];
    };

    tailscale = {
      enable = true;
      openFirewall = true;
    };

    # OpenSSH
    openssh = {
      enable = true;
      ports = [22];
      settings = {
        PasswordAuthentication = true;
        AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
        UseDns = true;
        X11Forwarding = true;
        PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      };
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
            "default.allowed-rates" = [192000 96000 48000 44100];
          };
        };
      };
    };

    blueman.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # "Essential" system packages
    home-manager
    neovim
    git
    wget
    curl
    gzip
    unzip
    ripgrep
    ddcutil

    # Terminal
    lazygit
    wl-clipboard
    nushell
    kitty

    docker-compose

    # Apps with no config currently
    pkgs.unstable.ollama
  ];

  users.defaultUserShell = pkgs.zsh;

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
        22 # OpenSSH
        57621 # Spotify
      ];
      allowedUDPPorts = [
        5353 # Spotify
        4242 # lan-mouse
      ];
    };
  };

  modules.system = {
    hardware.printing.enable = true;
    hardware.power.enable = false;
  };

  modules.sddm.enable = true;

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "history"
          "rust"
        ];
      };
    };

    kdeconnect.enable = true;

    thunar.enable = true;

    # direnv
    direnv.enable = true;
    direnv.silent = false;

    virt-manager.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    ssh.startAgent = true;

    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      withUWSM = true;
      # xwayland = true;
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

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

  # Configure console keymap
  console.keyMap = "us";

  # Pipewire realtime security
  security.rtkit.enable = true;

  system.stateVersion = "24.11";
}
