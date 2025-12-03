{
  inputs,
  outputs,
  pkgs,
  ...
}: let
  systemSettings = {
    hostname = "little";
    timezone = "Europe/Copenhagen";
    locale = "en_DK.UTF-8";
  };
in {
  imports = [
    outputs.nixosModules.stylix
    outputs.nixosModules.zealand
    outputs.nixosModules.hardware
    outputs.nixosModules.sddm
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

  i18n.defaultLocale = systemSettings.locale;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    # Networking
    hostName = systemSettings.hostname;
    networkmanager.enable = true;

    # Firewall
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        57621 # Spotify
      ];
      allowedUDPPorts = [
        5353 # Spotify
        4242 # lan-mouse
      ];
    };
  };

  # Locale
  time.timeZone = systemSettings.timezone;

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
    wl-clipboard
    nushell

		podman-compose
  ];

  # zealand.java.enable = true;
  zealand.jetbrains.enable = true;

  modules.system = {
    hardware.printing.enable = true;
    hardware.power.enable = false;
  };

	modules.sddm.enable = true;

  # zsh
  users.defaultUserShell = pkgs.zsh;

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

    thunar.enable = true;

    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      withUWSM = true;
      # xwayland = true;
    };

    # VM's
    virt-manager.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    # KDE Connect
    kdeconnect.enable = true;
  };

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;

    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    oci-containers.backend = "podman";
  };

  services = {
    timesyncd.enable = true;

    # OpenSSH
    openssh = {
      enable = true;
      ports = [22];
      settings = {
        PasswordAuthentication = true;
        AllowUsers = null;
        UseDns = true;
        X11Forwarding = true;
        PermitRootLogin = "prohibit-password";
      };
    };

    # Enable pipewire for sound
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    blueman.enable = true;

    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      excludePackages = [pkgs.xterm];

      # Configure keymap in X11
      xkb = {
        layout = "dk";
        variant = "";
      };
    };

    tailscale = {
      enable = true;
      openFirewall = true;
    };
  };

  hardware = {
    # Steam
    graphics.enable32Bit = true;

    # Bluetooth
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  # Configure console keymap
  console.keyMap = "dk-latin1";

  # Pipewire realtime security
  security.rtkit.enable = true;

  system.stateVersion = "24.11";
}
