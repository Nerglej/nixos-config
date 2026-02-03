{
  flake.homeModules.compositor =
    { lib, config, ... }:
    let
      monitor = import ./_monitor.nix;
    in
    {
      options.wij.compositor = {
        monitors = lib.mkOption {
          type = lib.types.attrsOf (lib.types.submodule monitor);
        };
      };
    };
}
