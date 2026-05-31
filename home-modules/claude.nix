{
  flake.homeModules."claude-code" =
    { pkgs, ... }:
    #let
    #  wrapped = pkgs.symlinkJoin {
    #    name = "claude";
    #    buildInputs = [ pkgs.makeWrapper ];
    #    paths = [ pkgs.unstable.claude-code ];
    #    postBuild = ''
    #      wrapProgram $out/bin/claude \
    #        --set CLAUDE_CONFIG_DIR "$XDG_CONFIG_HOME"/claude
    #    '';
    #  };
    #in
    {
      programs.claude-code.enable = true;
      programs.claude-code.package = pkgs.unstable.claude-code;
      programs.claude-code.settings = {
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
          # Presumably not yet in Claude Code in nixpkgs
          # StopFailure = [
          #   {
          #     hooks = [
          #       {
          #   	  type = "command";
          #    	  command = ''notify-send -a "Claude Code" "Stopped because of failure" -u critical'';
          #       }
          #     ];
          #   }
          # ];
        };
      };
    };
}
