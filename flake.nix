{
  description = "A very stolen nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    agenix = { url = "github:ryantm/agenix"; inputs.nixpkgs.follows = "nixpkgs"; inputs.home-manager.follows = "home-manager"; };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = { url = "github:nix-community/fenix"; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    lanzaboote = { url = "github:nix-community/lanzaboote"; inputs.nixpkgs.follows = "nixpkgs"; };
    neovim-nightly-overlay = { 
      url = "github:nix-community/neovim-nightly-overlay"; inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, agenix, fenix, home-manager, lanzaboote, ... 
  }: let
    inherit (self) outputs;
    nixosSystem = system: name:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs outputs; };
        modules = commonModules ++ [ ./machines/${name} ({...}: { networking.hostName = name; })];
      };
    commonModules = [
      agenix.nixosModules.age
      home-manager.nixosModule
      lanzaboote.nixosModules.lanzaboote
      ./modules
    ];  
  in
  {
    nixosConfigurations = {
      lich = nixosSystem "x86_64-linux" "lich";
    };
    overlays = [
      fenix.overlays.default
    ];
  };
}
