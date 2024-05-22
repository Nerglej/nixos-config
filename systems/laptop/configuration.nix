{ pkgs, host, ... }:

let 
  systemSettings = {
    system = "x86_64-linux";
    hostname = "laptop";
    timezone = "Europe/Copenhagen";
    locale = "en_DK.UTF-8";
  };
in
{
  imports = [       
    ../../modules/system/hardware/time.nix
    ../../modules/system/hardware/printing.nix
    ../../modules/system/hardware/bluetooth.nix
    ../../modules/system/hardware/power.nix
    # ../../system/hardware/fingerprint-reader.nix

    ( import ../../modules/system/config/locale.nix { locale = systemSettings.locale; } )
    
    ../../modules/system/apps/zsh.nix
    ../../modules/system/apps/direnv.nix
    ../../modules/system/apps/docker.nix
    ../../modules/system/apps/spotify.nix
    ../../modules/system/apps/steam.nix
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
  users.users = {
    "${ builtins.head host.users }" = {
      isNormalUser = true;
      description = "William Jelgren";
      extraGroups = ["networkmanager" "wheel" "docker"];
      packages = [];
      uid = 1000;
    }; 
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
    foot
    wl-clipboard
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.xserver.displayManager.defaultSession = "plasmawayland";
  services.xserver.displayManager.sddm.wayland.enable = true;

  services.xserver.excludePackages = [ pkgs.xterm ];
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    oxygen
  ];

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

  system.stateVersion = "23.11"; 
}
