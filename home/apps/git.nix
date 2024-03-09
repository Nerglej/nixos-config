{ config, pkgs, userSettings, ... }:

{
  home.packages = [ pkgs.git ];

  programs.git = {
    enable = true;
    userName = userSettings.name;
    userEmail = userSettings.email;

    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/home/" + userSettings.username + "/.dotfiles";

      credential.helper = "${
        pkgs.git.override { withLibsecret = true; }  
      }/bin/git-credential-libsecret";
    };
  };
}
