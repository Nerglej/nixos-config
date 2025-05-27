{
  inputs,
  outputs,
  lib,
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
    outputs.nixosModules.hardware
    ./hardware-configuration.nix
  ];

  # Allow unfree packages
  nixpkgs = {
    config.allowUnfree = true;
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

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
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

    # KDE Plasma
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;

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
    };
  };

  environment.systemPackages = with pkgs; [
    # "Essential" system packages
    home-manager
    vim
    git
    wget
    curl
    gzip
    unzip

    # Terminal
    lazygit
    wl-clipboard
    nushell

    # Apps with no config currently
    obsidian
    spotify
    pkgs.unstable.ollama
  ];

  # KDE Plasma Desktop Environment
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kdepim-runtime
    oxygen
    konsole
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

    # direnv
    direnv.enable = true;
    direnv.silent = false;

    virt-manager.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;

    docker.enable = true;
    docker.enableOnBoot = false;
  };

  # Configure console keymap
  console.keyMap = "us";

  # Pipewire realtime security
  security.rtkit.enable = true;

  system.stateVersion = "24.11";
}
