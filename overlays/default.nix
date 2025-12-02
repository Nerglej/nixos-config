{inputs, ...}: {
  additions = final: _prev: import ../pkgs final.pkgs;

  unstable-packages = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = prev.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
}
