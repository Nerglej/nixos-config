{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.stylix
  ];

  nixpkgs.overlays = [ inputs.self.overlays.unstable-packages ];
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      # custom apps
      "steam"
      "steam-unwrapped"
      "spotify"
      "zoom"

      # required for nvidia driver
      "nvidia-x11"
      "nvidia-settings"

      # required for ollama and nvidia
      # "cuda_cudart"
      # "libcublas"
      # "cuda_cccl"
      # "cuda_nvcc"
    ];

  nix = {
    package = pkgs.nixVersions.stable;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    channel.enable = false;
  };

  environment.systemPackages = with pkgs; [
    home-manager
    neovim
    git
    at
    wget
    curl
    gzip
    zip
    unzip
    ripgrep
    wl-clipboard
    podman-compose
  ];

  # Use zsh as default shell
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

  programs.ssh.startAgent = true;

  programs.thunar.enable = true;
  programs.kdeconnect.enable = true;
  programs.virt-manager.enable = true;

  services.atd.enable = true;
  services.timesyncd.enable = true;
  services.blueman.enable = true;

  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    openFirewall = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
      UseDns = true;
      X11Forwarding = true;
      PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;

    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    oci-containers.backend = "podman";
  };
}
