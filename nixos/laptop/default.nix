{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  systemSettings = {
    hostname = "laptop";
    timezone = "Europe/Copenhagen";
    locale = "en_DK.UTF-8";
  };
in {
  imports = [
    ./hardware-configuration.nix
    (import ../../modules/system/config/locale.nix {locale = systemSettings.locale;})
    ../../modules/system
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [outputs.overlays.unstable-packages];

  # Fix nix path
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=$HOME/dotfiles/system/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  nix.package = pkgs.nixVersions.stable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = systemSettings.hostname;
  networking.networkmanager.enable = true;

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

  modules.system = {
    hardware.printing.enable = true;
    hardware.power.enable = false;

    school.java.enable = true;
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
  users.groups.libvertd.members = ["williamj"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = false;
  users.extraGroups.docker.members = ["williamj"];

  services.timesyncd.enable = true;

  # Steam
  hardware.graphics.enable32Bit = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Spotify - Discover casting devices and something something filesystem on network
  networking.firewall.allowedTCPPorts = [57621];
  networking.firewall.allowedUDPPorts = [5353];

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # KDE Plasma Desktop Environment
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    oxygen
  ];

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
