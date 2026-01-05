{
  lib,
  config,
  ...
}:
let
  cfg = config.wij.git;
in
{
  options.wij.git = {
    enable = lib.mkEnableOption "enable git";

    name = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      example = "John Doe";
    };

    email = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      example = "john@example.com";
    };

    defaultBranch = lib.mkOption {
      type = lib.types.str;
      default = "main";
      example = "master";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;

      settings = {
        user.name = lib.mkIf (cfg.name != null) cfg.name;
        user.email = lib.mkIf (cfg.email != null) cfg.email;

        init.defaultBranch = cfg.defaultBranch;

        # Credential helper not needed when using SSH keys
        # credential.helper = "${
        #   pkgs.git.override {
        #     withLibsecret = true;
        #   }
        # }/bin/git-credential-libsecret";
      };
    };
  };
}
