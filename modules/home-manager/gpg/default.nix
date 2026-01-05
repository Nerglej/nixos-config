{ pkgs, ... }:
{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    pinentry.package = pkgs.pinentry-qt;
    pinentry.program = "pinentry-qt";
  };

  home.packages = [
    pkgs.pinentry-qt
  ];
}
