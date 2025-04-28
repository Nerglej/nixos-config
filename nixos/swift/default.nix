{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  systemSettings = {
    hostname = "swift";
    timezone = "Europe/Copenhagen";
    locale = "en_DK.UTF-8";
  };
in {
  imports = [
    outputs.nixosModules.hardware
    ./hardware-configuration.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [outputs.overlays.unstable-packages];

  nix.package = pkgs.nixVersions.stable;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.channel.enable = false;

  i18n.defaultLocale = systemSettings.locale;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = systemSettings.hostname;
  networking.networkmanager.enable = true;

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      57621 # Spotify
    ];
    allowedUDPPorts = [
      5353 # Spotify
    ];
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
    inputs.zen-browser.packages."x86_64-linux".default
  ];

  modules.system = {
    hardware.printing.enable = true;
    hardware.power.enable = false;
  };

  # zsh
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
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
  programs.direnv.enable = true;
  programs.direnv.silent = false;

  # VM's
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = false;

  services.timesyncd.enable = true;

  # Steam
  hardware.graphics.enable32Bit = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # NVidia sucks
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = [pkgs.nvidia-vaapi-driver];
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.open = true;

  # KDE Plasma Desktop Environment
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    oxygen
  ];

  # KDE Connect
  programs.kdeconnect.enable = true;

  services.xserver.excludePackages = [pkgs.xterm];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "dk-latin1";

  # Enable pipewire for sound
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  system.stateVersion = "24.11";
}
