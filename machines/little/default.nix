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
      ./_hardware-configuration.nix

      inputs.self.nixosModules.commonModule
      inputs.self.nixosModules.littleModule

      inputs.self.nixosModules.sddm-astronaut
      inputs.self.nixosModules.printing
      inputs.self.nixosModules.power
      inputs.self.nixosModules.mangowc
      inputs.self.nixosModules.stylix

      inputs.home-manager.nixosModules.home-manager
    ];
  };

  flake.nixosModules.littleModule =
    { pkgs, ... }:
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users."williamj" = inputs.self.homeConfigurations."williamj@little";

        extraSpecialArgs = { inherit inputs; };
      };

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
          ];
        };
      };

      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
      };

      services = {
        xserver = {
          # Enable the X11 windowing system.
          enable = true;

          excludePackages = [ pkgs.xterm ];

          # Configure keymap in X11

          xkb.layout = "dk";
          xkb.variant = "";
        };

        # Enable pipewire for sound
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
        };

        upower.enable = true;
      };

      hardware = {
        # Steam
        graphics.enable32Bit = true;

        # Bluetooth
        bluetooth.enable = true;
        bluetooth.powerOnBoot = true;
      };

      environment.systemPackages = with pkgs; [
        amdgpu_top
      ];

      # Pipewire realtime security
      security.rtkit.enable = true;

      system.stateVersion = "24.11";
    };
}
