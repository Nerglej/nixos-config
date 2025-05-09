{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.zealand.java;

  jdk = pkgs.jdk21.override {enableJavaFX = true;};

  maven = pkgs.maven.override {jdk_headless = jdk;};
  gradle = pkgs.gradle.override {java = jdk;};
in {
  options.zealand.java = {
    enable = mkEnableOption "Enable java development for Zealand";
  };

  config = mkIf cfg.enable {
    programs.java = {
      enable = true;
      package = jdk;
    };

    environment.systemPackages = with pkgs; [
      jdk
      maven
      gradle

      jetbrains.idea-ultimate
    ];

    environment.etc."21".source = jdk;
  };
}
