{
  flake.homeModules.compositor =
    { lib, config, ... }:
    let
      monitor = import ./monitor.nix;
    in
    {
      options.wij.compositor = {
        monitors = lib.mkOption {
          type = lib.types.attrsOf (lib.types.submodule monitor);
        };
      };
    };
}
