{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};

        jdk-version = "21";
        jdk = pkgs."jdk${jdk-version}";

        maven = pkgs.maven.override {jdk_headless = jdk;};
        gradle = pkgs.gradle.override {java = jdk;};
      in {
        devShell = with pkgs;
          mkShell {
            nativeBuildInputs = [pkg-config];
            buildInputs = [
              jdk
              maven
              gradle
            ];

            environment.etc.${jdk-version}.source = jdk;
          };
      }
    );
}
