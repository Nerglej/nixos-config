{
  pkgs,
  lib,
  config,
  ...
}:
let
  dir = ./screenshots;

  files = builtins.filter (name: (builtins.readDir dir).${name} == "regular") (
    builtins.attrNames (builtins.readDir dir)
  );

  mkWrapper =
    name:
    pkgs.writeShellScriptBin name ''
      #!/${pkgs.bash}/bin/bash
      exec ${dir}/${name} "$@"
    '';

  scripts = map mkWrapper files;

  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.wil.screenshots;
in
{
  options.wil.screenshots = {
    enable = mkEnableOption "screenshots";
  };

  config = mkIf cfg.enable {
    packages =
      with pkgs;
      [
        grim
        slurp
      ]
      ++ scripts;
  };
}
