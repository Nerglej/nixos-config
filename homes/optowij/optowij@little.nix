{
  flake.homeConfigurations."optowij@little" =
    { inputs, pkgs, ... }:
    {
      imports = [
        inputs.self.homeConfigurations.optowij

        inputs.self.homeModules.compositor
        inputs.self.homeModules.mangowc
      ];

      wij.compositor.monitors = {
        "eDP-1" = {
          width = 1920;
          height = 1080;
          refresh = 60;
          x = 0.0;
          y = 1440.0;
          scale = 1.0;
        };
        "HDMI-A-1" = {
          width = 2560;
          height = 1440;
          refresh = 60;
          x = 0.0;
          y = 0.0;
          scale = 1.0;
        };
      };

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
