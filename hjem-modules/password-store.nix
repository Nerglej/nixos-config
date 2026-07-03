{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.wil.password-store;

  password-store = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
  password-store-wrapped = pkgs.symlinkJoin {
    name = "password-store";
    paths = [ password-store ];
    buildInputs = with pkgs; [ makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/pass \
        --set PASSWORD_STORE_DIR '${config.xdg.data.directory}/password-store' \
        --set PASSWORD_STORE_EXTENSIONS_DIR '${config.xdg.state.directory}/password-store/extensions'
    '';
  };
in
{
  options.wil.password-store = {
    enable = mkEnableOption "password-store";
  };

  config = mkIf cfg.enable {
    packages = [
      password-store-wrapped
    ];
  };
}
