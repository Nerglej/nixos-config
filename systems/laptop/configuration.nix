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
    ( import ../../modules/system/config/locale.nix { locale = systemSettings.locale; } )
    ../../modules/system
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
      extraGroups = ["networkmanager" "wheel"];
      packages = [];
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
    
    # Apps with no config currently
    obsidian
    rquickshare
  ];

  modules.system = {
    shell.zsh.enable = true;
    shell.zsh.defaultShell = true;

    shell.nushell.enable = true;
    shell.direnv.enable = true;

    apps.steam.enable = true;
    apps.spotify.enable = true;
    apps.ollama.enable = true;

    virtualization.docker.enable = true;
    virtualization.docker.users = ["${builtins.head host.users }"];

    hardware.printing.enable = true;
    hardware.power.enable = true;

    school.java.enable = true;
  };

  services.timesyncd.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

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
