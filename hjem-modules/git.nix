{
  flake.modules.hjem.git =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      inherit (lib.modules) mkIf;
      inherit (lib.options) mkEnableOption;
      inherit (lib) mkOption;

      cfg = config.wil.git;
    in
    {
      options.wil.git = {
        enable = mkEnableOption "git";

        name = mkOption {
          type = lib.types.nullOr lib.types.str;
          example = "John Doe";
        };

        email = mkOption {
          type = lib.types.nullOr lib.types.str;
          example = "john@example.com";
        };

        defaultBranch = mkOption {
          type = lib.types.str;
          default = "main";
          example = "master";
        };
      };

      config = mkIf cfg.enable {
        rum.programs.git = {
          enable = true;

          ignore = ''
            .direnv
          '';

          settings = {
            user.name = lib.mkIf (cfg.name != null) cfg.name;
            user.email = lib.mkIf (cfg.email != null) cfg.email;

            init.defaultBranch = cfg.defaultBranch;
          };
        };
      };
    };
}
