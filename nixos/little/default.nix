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
    inputs.stylix.nixosModules.stylix
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

  # Bootloader.
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

  zealand.java.enable = true;

  modules.system = {
    hardware.printing.enable = true;
    hardware.power.enable = false;
  };

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

    # direnv
    direnv = {
      enable = true;
      silent = false;
    };

    # Hyprland
    hyprland = {
      enable = true;
      withUWSM = true;
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

  stylix = {
    enable = true;
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    base16Scheme = {
      base00 = "282828";
      base01 = "3c3836";
      base02 = "504945";
      base03 = "665c54";
      base04 = "bdae93";
      base05 = "d5c4a1";
      base06 = "ebdbb2";
      base07 = "fbf1c7";
      base08 = "fb4934";
      base09 = "fe8019";
      base0A = "fabd2f";
      base0B = "b8bb26";
      base0C = "8ec07c";
      base0D = "83a598";
      base0E = "d3869b";
      base0F = "d65d0e";
    };
    image = ../../fractal-flower.jpg;
    fonts = {
      monospace = {
        package = pkgs.commit-mono;
        name = "CommitMono Nerd Font";
      };
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    opacity.terminal = 0.9;

    targets.nvf.enable = false;
    targets.nixvim.enable = false;
  };

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;

    # Docker
    docker.enable = true;
    docker.enableOnBoot = false;
  };

  services = {
    timesyncd.enable = true;

    # KDE Plasma Desktop Environment
    displayManager.sddm.enable = true;

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
