{
  description = "A very stolen nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "darwin";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dts-prv = {
      # private flake
      url = "git+ssh://git@github.com/theglitch76/dts-prv";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.darwin.follows = "darwin";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # the flake.nix for mac-app-util seems to imply they want to use their own nixpkgs
    mac-app-util.url = "github:hraban/mac-app-util";
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      inherit (self) outputs;
      patches = builtins.map (patch: ./patches + "/${patch}") (builtins.filter (x: x != ".keep") (builtins.attrNames (builtins.readDir ./patches)));
      # Avoid IFD if there are no patches
      nixpkgsForSystem = system: if patches == [ ] then inputs.nixpkgs else
      (
        ((import inputs.nixpkgs { inherit system; }).pkgs.applyPatches {
          inherit patches;
          name = "nixpkgs-patched-${inputs.nixpkgs.shortRev}";
          src = inputs.nixpkgs;
        }).overrideAttrs (old: {
          preferLocalBuild = false;
          allowSubstitutes = true;
        })
      );
      configureHome = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.glitch = import ./modules/home/default.nix;
          # TODO: this is a little jank...
          sharedModules = commonHomeManagerModules ++ [ (
            { ... }:
            {
             home.stateVersion = stateVersion;
            }
          )
          ];
          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };
      };
      nixosSystem =
        system: name:
        let
          nixpkgs = nixpkgsForSystem system;
          lib = (import nixpkgs { inherit overlays system; }).lib;
        in
        inputs.nixpkgs.lib.nixosSystem {
          inherit lib system;
          specialArgs = {
            inherit inputs outputs;
          };
          modules = commonNixosModules ++ [
            (
              { ... }:
              {
                networking.hostName = name;
                system.stateVersion = stateVersion;
                nixpkgs.pkgs = import nixpkgs {
                  inherit overlays system;
                  config.allowUnfree = true; # free software is for losers
                };
                home-manager.users.glitch = import ./machines/${name}/home.nix;
              }
            )
            ./machines/${name}/nixos.nix
          ];
        };
      darwinSystem = name:
        let
          system = "aarch64-darwin"; # ill probably never own an intel mac, right...?
          nixpkgs = nixpkgsForSystem system;
          lib = (import nixpkgs { inherit overlays system; }).lib;
        in
          inputs.darwin.lib.darwinSystem {
            specialArgs = {
              inherit inputs outputs;
            };
            inherit lib system;
            modules = commonDarwinModules ++ [
              {
                home-manager.users.glitch = import ./machines/${name}/home.nix;
                nixpkgs.pkgs = import nixpkgs {
                  inherit overlays system;
                  config.allowUnfree = true; # free software is for losers
                };
              }
              ./machines/${name}/darwin.nix
            ];
          };
      commonNixosModules = with inputs; [
	agenix.nixosModules.default
        home-manager.nixosModules.home-manager configureHome
        lanzaboote.nixosModules.lanzaboote
#        lix-module.nixosModules.default
        ./modules/nixos
      ];
      commonDarwinModules = with inputs; [
	agenix.darwinModules.default
        home-manager.darwinModules.home-manager configureHome
        mac-app-util.darwinModules.default
        ./modules/darwin
      ];
      commonHomeManagerModules = with inputs; [
        mac-app-util.homeManagerModules.default
        dts-prv.homeManagerModules.default
      ];
      stateVersion = "24.05";
      nixosConfigurations = {
        lich = nixosSystem "x86_64-linux" "lich";
        lich-wsl = nixosSystem "x86_64-linux" "lich-wsl";
        aboleth = nixosSystem "x86_64-linux" "aboleth";
      };
      darwinConfigurations = {
        braize = darwinSystem "braize";
      };
      overlays = with inputs; [
        emacs-overlay.overlays.default
        devshell.overlays.default
        lix.overlays.lixFromNixpkgs
      ];

      lsShells = builtins.readDir ./shells;
      shellFiles = builtins.filter (name: lsShells.${name} == "regular") (builtins.attrNames lsShells);
      shellNames = builtins.map (filename: builtins.head (builtins.split "\\." filename)) shellFiles;
      systemAttrs = inputs.flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = import nixpkgs {inherit overlays system; };
          lib = pkgs.lib;
          nameToValue = name: import (./shells + "/${name}.nix") {inherit lib pkgs inputs system; };
        in
          {
            devShells = builtins.listToAttrs(builtins.map (name: {inherit name; value = nameToValue name;}) shellNames);
          }
      );
    in systemAttrs // { inherit nixosConfigurations darwinConfigurations shellNames; };
}
