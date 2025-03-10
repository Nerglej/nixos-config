{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.modules.system.school.java;

  jdk = (pkgs.jdk21.override { enableJavaFX = true; });

  maven = pkgs.maven.override { jdk_headless = jdk; };
  gradle = pkgs.gradle.override { java = jdk; };
in {
  options.modules.system.school.java = {
    enable = mkEnableOption "Enable java development for school";
  };

  config = mkIf cfg.enable {
    programs.java = {
      enable = true;
      package = jdk;
    };

    environment.systemPackages = with pkgs; [
      jdk
      javaPackages.openjfx21

      maven
      gradle

      jetbrains.idea-community
      jetbrains.idea-ultimate

      scenebuilder
      libGL
    ];

    environment.etc."21".source = jdk;
  };
}
