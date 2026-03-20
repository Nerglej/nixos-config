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
        users."optowij" = inputs.self.homeConfigurations."optowij@little";

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
          uid = 1000;
          isNormalUser = true;
          description = "William Jelgren";
          extraGroups = [
            "wheel" # Allows user to run `sudo`
            "networkmanager" # Allows network management
            "libvirtd" # Management of virtual machines
          ];
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIElU3Z+2DyeacMQmnMsLoqciaKboKddIwv/LYrWbL2K5 williamj@emperor"
          ];
        };
        "optowij" = {
          uid = 1001;
          isNormalUser = true;
          description = "William (Optoceutics)";
          initialHashedPassword = "$6$jgX3WhhNPUW5A371$1u4EI8SW7wIngT5ZxsBw74ITviClPEt59G4ehhK2ZR8Ggak6slWeyn2eeztahUhy8JzyHCRa7y4VztACpk8o20";
          extraGroups = [
            "networkmanager" # Allows network management
            "libvirtd" # Management of virtual machines
          ];
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
        unstable.ollama-vulkan
      ];

      # Pipewire realtime security
      security.rtkit.enable = true;

      system.stateVersion = "24.11";
    };
}
