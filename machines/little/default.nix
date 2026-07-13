{
  inputs,
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
  flake.nixosConfigurations."little" = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };

    modules = [
      inputs.preservation.nixosModules.default

      inputs.self.nixosModules.commonModule
      inputs.self.nixosModules.littleModule

      # inputs.self.nixosModules.sddm-astronaut
      inputs.self.nixosModules.ly

      inputs.self.nixosModules.printing
      inputs.self.nixosModules.power
      inputs.self.nixosModules.mangowc

      inputs.self.nixosModules."williamj@little"
      inputs.self.nixosModules."optowij@little"

      ./hardware-configuration.nix
      ./preservation.nix
    ];
  };

  flake.nixosModules.littleModule =
    { pkgs, ... }:
    {
      # Locale
      time.timeZone = systemSettings.timezone;
      i18n.defaultLocale = systemSettings.locale;
      console.keyMap = "dk-latin1";

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
            57621 # Spotify
          ];
          allowedUDPPorts = [
            5353 # Spotify
          ];
        };
      };

      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
      };

      # Enable pipewire for sound
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      services.upower.enable = true;

      hardware = {
        # Steam
        graphics.enable32Bit = true;

        # Bluetooth
        bluetooth.enable = true;
        bluetooth.powerOnBoot = true;
      };

      environment.systemPackages = with pkgs; [
        amdgpu_top
        unstable.ollama-vulkan
      ];

      # Pipewire realtime security
      security.rtkit.enable = true;

      system.stateVersion = "24.11";
    };
}
