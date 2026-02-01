{
  flake.homeModules.password-store =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      cfg = config.wij.password-store;
    in
    {
      options.wij.password-store = {
        enable = lib.mkEnableOption "enable password-store";
      };

      config = lib.mkIf cfg.enable {
        programs.password-store = {
          enable = true;
          package = pkgs.pass.withExtensions (exts: with exts; [ pass-otp ]);
          settings = {
            PASSWORD_STORE_DIR = "$HOME/.password-store";
          };
        };
      };
    };
}
