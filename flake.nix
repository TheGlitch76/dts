{
  description = "A very stolen nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
#      inputs.lix.follows = "lix";
    };
    madness.url = "github:antithesishq/madness";
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      inherit (self) outputs;
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
                home-manager.users.glitch = { ... }: { home.stateVersion = stateVersion; };
              }
            )
            ./machines/${name}
          ];
        };
      commonNixosModules = with inputs; [
        agenix.nixosModules.age
        home-manager.nixosModule {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.glitch = import ./modules/home/default.nix;
        }
        lanzaboote.nixosModules.lanzaboote
        lix-module.nixosModules.default
        madness.nixosModules.madness
        ./modules/nixos
      ];
      
      stateVersion = "24.05";
    in
    {
      nixosConfigurations = {
        lich = nixosSystem "x86_64-linux" "lich";
      };
      homeConfigurations."glitch@shadesmar" = inputs.home-manager.lib.homeManagerConfiguration {

        pkgs = nixpkgs.legacyPackages."aarch64-linux";
        extraSpecialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./machines/shadesmar-fedora
          ./modules/home
          (
            { ... }:
            {
              home = {
                inherit stateVersion;
                username = "glitch";
                homeDirectory = "/home/glitch";
              };
              nixpkgs.overlays = self.overlays;
            }
          )
        ];
      };
      overlays = [ inputs.emacs-overlay.overlays.default ];
    };
}
