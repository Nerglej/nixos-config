let
  # Function to map all directories to an attribute set
  # where each attribute imports the directory's default.nix
  importModules =
    path:
    let
      entries = builtins.readDir path;
      dirNames = builtins.filter (name: entries.${name} == "directory") (builtins.attrNames entries);
      dirsToAttrs = builtins.listToAttrs (
        map (name: {
          name = name;
          value = ./. + "/${name}";
        }) dirNames
      );
    in
    dirsToAttrs;
in
{
  flake.homeModules = importModules ./.;
}
