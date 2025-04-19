{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  options.glitch = { };
  config = {
    home-manager.useGlobalPkgs = true;
    # packages so common i want them literally everywhere
    environment.systemPackages = with pkgs; [ git ripgrep ];
    programs = {
      fish.enable = true;
      #      nushell.enable = true; # just here for fun
    };
    nixpkgs.config.allowUnfree = true; # free software is for losers
    nix = {
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      optimise.automatic = true;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [
          "https://cache.nixos.org"
          "https://accentor.cachix.org"
          "https://lanzaboote.cachix.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "accentor.cachix.org-1:QP+oJwzmeq5Fsyp4Vk501UgUSbl5VIna/ard/XOePH8="
          "lanzaboote.cachix.org-1:Nt9//zGmqkg1k5iu+B3bkj3OmHKjSw9pvf3faffLLNk="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        trusted-users = [ "@wheel" ];
      };
    };
  };
}
