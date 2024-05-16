{ user, pkgs, inputs, ... }:

let
  userSettings = {
    username = user;
    name = "William Jelgren";
    email = "william@jelgren.dk";
    editor = "nvim";
    terminal = "foot";
    shellAliases = {
      ll = "ls -l";
    };
  };
in
{
  inherit pkgs;
  modules = [ 
    ./home.nix 
  ];
  extraSpecialArgs = {
    inherit userSettings;
    inherit inputs;
  };
}
