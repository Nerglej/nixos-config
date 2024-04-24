{
  description = "Williams NixOS";
  
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim/nixos-23.11";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
  let 
    # ---- System Settings ---- #
    systemSettings = {
      system = "x86_64-linux";
      hostname = "system";
      profile = "personal";
      timezone = "Europe/Copenhagen";
      locale = "en_DK.UTF-8";
      stateVersion = "23.11";
    };
      
    # ---- User Settings ---- #
    userSettings = {
      username = "williamj";
      name = "William Jelgren";
      email = "william@jelgren.dk";
      editor = "nvim";
      shellAliases = {
        ll = "ls -l";
      };
    };

    lib = nixpkgs.lib;

    pkgs = import nixpkgs {
      system = systemSettings.system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
    };

    supportedSystems = [
      "x86_64-linux"
    ];
   
    forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;

    nixpkgsFor = forAllSystems (system: import inputs.nixpkgs { inherit system; });
  in {
    nixosConfigurations = {
      system = lib.nixosSystem {
        system = systemSettings.system;
        modules = [ (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix") ];
        specialArgs = {
          inherit systemSettings;
          inherit userSettings;
        };
      };
    };

    homeConfigurations = {
      williamj = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix") ];
        extraSpecialArgs = {
          inherit systemSettings;
          inherit userSettings;
          inherit inputs;
        };
      };
    };

    packages = forAllSystems (system:
      let pkgs = nixpkgsFor.${system}; in {
        default = self.packages.${system}.install;
        install = pkgs.writeScriptBin "install" ./install.sh;
      });

    apps = forAllSystems (system: {
      default = self.apps.${system}.install;
     
      install = {
        type = "app";
        program = "${self.packages.${system}.install}/bin/install";
      };
    });
  };
}
