{ pkgs, lib, systemSettings, userSettings, ... }:

{
  imports = [       
    ../../system/hardware-configuration.nix
    ../../system/hardware/time.nix
    ../../system/hardware/printing.nix
    ../../system/hardware/bluetooth.nix
    ../../system/hardware/power.nix
    # ../../system/hardware/fingerprint-reader.nix

    ../../system/config/locale.nix
    
    ../../system/apps/zsh.nix
    ../../system/apps/direnv.nix
    ( import ../../system/apps/docker.nix { inherit userSettings lib; } )
    ../../system/apps/spotify.nix
    ../../system/apps/steam.nix
    ../../system/apps/zoom.nix
    ../../system/apps/discord.nix
  ];

  # Fix nix path
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=$HOME/dotfiles/system/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];
  
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Networking
  networking.hostName = systemSettings.hostname; 
  networking.networkmanager.enable = true;

  # Locale 
  time.timeZone = systemSettings.timezone;

  # User account
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = ["networkmanager" "wheel"];
    packages = [];
    uid = 1000;
  };
  
  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    gzip
    unzip
    git
    home-manager
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.xserver.displayManager.defaultSession = "plasmawayland";
  services.xserver.displayManager.sddm.wayland.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "dk";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "dk-latin1";

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  system.stateVersion = systemSettings.stateVersion; 
}
