{
  inputs,
  outputs,
  pkgs,
  ...
}:
let
  systemSettings = {
    hostname = "little";
    timezone = "Europe/Copenhagen";
    locale = "en_DK.UTF-8";
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ../common

    outputs.nixosModules.zealand
    outputs.nixosModules.sddm
    outputs.nixosModules.hardware
  ];

  # Locale
  time.timeZone = systemSettings.timezone;
  i18n.defaultLocale = systemSettings.locale;
  console.keyMap = "dk-latin1";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  networking = {
    # Networking
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
        4242 # lan-mouse
      ];
    };
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      withUWSM = true;
      # xwayland = true;
    };
  };

  services = {
    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      excludePackages = [ pkgs.xterm ];

      # Configure keymap in X11
      xkb = {
        layout = "dk";
        variant = "";
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

  zealand.jetbrains.enable = true;

  modules.sddm.enable = true;
  modules.system = {
    hardware.printing.enable = true;
    hardware.power.enable = false;
  };

  hardware = {
    # Steam
    graphics.enable32Bit = true;

    # Bluetooth
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  # Pipewire realtime security
  security.rtkit.enable = true;

  system.stateVersion = "24.11";
}
