{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.modules.system.school.java;

  jdkVersion = "21";

  jdk = pkgs."jdk${jdkVersion}";
  # maven = pkgs.maven.override { jdk_headless = jdk; };
  gradle = pkgs.gradle.override { java = jdk; };
in {
  options.modules.system.school.java = {
    enable = mkEnableOption "Enable java development for school";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      jdk
      jdk22
      maven
      gradle

      jetbrains.idea-ultimate
      jetbrains.idea-community
      scenebuilder
    ];

    environment.etc."jdk${jdkVersion}".source = jdk;
    environment.etc."jdk22".source = pkgs.jdk22;
  };
}
