{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    outputs.nixosModules.stylix
  ];

  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
    overlays = [ outputs.overlays.unstable-packages ];
  };

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
