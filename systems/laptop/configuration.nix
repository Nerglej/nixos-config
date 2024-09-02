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
    ../../modules/system/apps/nushell.nix
    ../../modules/system/apps/direnv.nix
    ../../modules/system/apps/docker.nix
    ../../modules/system/apps/rquickshare.nix
    ../../modules/system/apps/spotify.nix
    ../../modules/system/apps/steam.nix
    ../../modules/system/apps/obsidian.nix
    ../../modules/system/apps/intellij.nix
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
    lazygit
    home-manager
    foot
    wl-clipboard
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    oxygen
  ];

  services.xserver.excludePackages = [ pkgs.xterm ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "dk";
    variant = "";
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

  system.stateVersion = "24.05"; 
}
