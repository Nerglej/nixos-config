{
  flake.modules.hjem.bemenu =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      dir = ./bemenu;

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

      cfg = config.wil.bemenu;

      bemenu-opts = "--line-height 28 --list 15 --prompt open --prefix > --ignorecase --width-factor 0.2 --center --vim-normal-mode --vim-esc-exits --no-cursor --border-radius 8 --single-instance";

      bemenu-wrapped =
        with pkgs;
        symlinkJoin {
          name = "bemenu";
          paths = [ bemenu ];
          buildInputs = [ makeWrapper ];

          postBuild = ''
            for b in bemenu bemenu-run; do
              wrapProgram $out/bin/$b \
                --set BEMENU_OPTS '${bemenu-opts}'
            done
          '';
        };
    in
    {
      options.wil.bemenu = {
        enable = mkEnableOption "bemenu";
      };

      config = mkIf cfg.enable {
        packages =
          with pkgs;
          [
            bemenu-wrapped

            # Helpers for the scripts
            jq
          ]
          ++ scripts;
      };
    };
}
