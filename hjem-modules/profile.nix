{
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
in
{
  # some compositors and shells need this file:
  # - greetd
  config.files.".profile" = mkIf (config.environment.sessionVariables != { }) {
    source = config.environment.loadEnv;
  };
}
