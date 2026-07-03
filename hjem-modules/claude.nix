{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.wil.claude-code;

  claude-wrapped = pkgs.symlinkJoin {
    name = "claude-code";
    paths = [ pkgs.unstable.claude-code ];
    buildInputs = with pkgs; [ makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude \
        --set CLAUDE_CONFIG_DIR '${config.xdg.config.directory}/claude'
    '';
  };
in
{
  options.wil.claude-code = {
    enable = mkEnableOption "claude-code";
  };

  config = mkIf cfg.enable {
    packages = [ claude-wrapped ];

    xdg.config.files."claude/settings.json" = {
      generator = lib.generators.toJSON { };
      value = {
        hooks = {
          PermissionRequest = [
            {
              hooks = [
                {
                  type = "command";
                  command = ''notify-send -a "Claude Code" "Permission requested"'';
                }
              ];
            }
          ];
          Stop = [
            {
              hooks = [
                {
                  type = "command";
                  command = ''notify-send -a "Claude Code" "Successfully done working"'';
                }
              ];
            }
          ];
        };
      };
      clobber = true;
    };
  };
}
