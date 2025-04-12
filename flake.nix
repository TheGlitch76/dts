{
  description = "A very stolen nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.darwin.follows = "darwin";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
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
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # the flake.nix for mac-app-util seems to imply they want to use their own nixpkgs
    mac-app-util.url = "github:hraban/mac-app-util";
    madness.url = "github:antithesishq/madness";
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      inherit (self) outputs;
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
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs outputs;
          };
          modules = commonNixosModules ++ [
            (
              { ... }:
              {
                networking.hostName = name;
                system.stateVersion = stateVersion;

                nixpkgs.overlays = overlays;

                home-manager.users.glitch = import ./machines/${name}/home.nix;
              }
            )
            ./machines/${name}/nixos.nix
          ];
        };
      darwinSystem = name: inputs.darwin.lib.darwinSystem {
        system = "aarch64-darwin"; # ill probably never own an intel mac, right...?
        specialArgs = {
          inherit inputs outputs;
        };
        modules = commonDarwinModules ++ [
          {
            home-manager.users.glitch = import ./machines/${name}/home.nix;
            nixpkgs.overlays = overlays;
          }
          ./machines/${name}/darwin.nix
        ];
      };

      commonNixosModules = with inputs; [
        agenix.nixosModules.default
        home-manager.nixosModules.home-manager configureHome
        lanzaboote.nixosModules.lanzaboote
#        lix-module.nixosModules.default
        madness.nixosModules.madness
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
      ];
      stateVersion = "24.05";
      nixosConfigurations = {
        lich = nixosSystem "x86_64-linux" "lich";
        lich-wsl = nixosSystem "x86_64-linux" "lich-wsl";
      };
      darwinConfigurations = {
        braize = darwinSystem "braize";
      };
      overlays = with inputs; [
        emacs-overlay.overlays.default
        devshell.overlays.default
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
