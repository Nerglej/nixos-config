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
    inputs.stylix.nixosModules.stylix
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
    kernelModules = ["i2c-dev" "ddcci_backlight"];
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="i2c-dev", ACTION=="add",\
      ATTR{name}=="NVIDIA i2c adapter*",\
      TAG+="ddcci",\
      TAG+="systemd",\
      ENV{SYSTEMD_WANTS}+="ddcci@$kernel.service"
  '';

  systemd.services."ddcci@" = {
    scriptArgs = "%i";
    script = ''
      echo Trying to attach ddcci to $1
      i=0
      id=$(echo $1 | cut -d "-" -f 2)
      counter=5
      while [ $counter -gt 0 ]; do
        if ${pkgs.ddcutil}/bin/ddcutil getvcp 10 -b $id; then
          echo ddcci 0x37 > /sys/bus/i2c/devices/$1/new_device
          echo ddcci attached to $1
        fi
        sleep 30
        counter=$((counter - 1))
      done
    '';
    serviceConfig.Type = "oneshot";
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

    # Login screen thing
    displayManager.sddm = {
      enable = true;
      theme = "catppuccin-mocha";
      package = pkgs.kdePackages.sddm;
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
    };

    blueman.enable = true;
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
    ripgrep
    ddcutil
    deploy-rs

    base16-schemes

    # Terminal
    lazygit
    wl-clipboard
    nushell
    kitty

    (
      catppuccin-sddm.override {
        flavor = "mocha";
        # font= "";
        fontSize = "9";
        # background = ./;
        loginBackground = true;
      }
    )

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

    ssh.startAgent = true;

    hyprland = {
      enable = true;
      withUWSM = true;
      # xwayland = true;
    };
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
