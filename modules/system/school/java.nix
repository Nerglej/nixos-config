{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.modules.system.school.java;

  # Using version 21 instead of the newest, so scenebuilder want to work
  defaultVersion = "21";

  jdk = pkgs."jdk${defaultVersion}";

  maven = pkgs.maven.override { jdk = jdk; };
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

      jetbrains.idea-community
      jetbrains.idea-ultimate
      scenebuilder
    ];

    environment.etc."${defaultVersion}".source = jdk;
    environment.etc."jdk22".source = pkgs.jdk22;
  };
}
