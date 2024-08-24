{ inputs, outputs, config, lib, pkgs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
#    ./zsh
  ];
  options.glitch = {};
  config = {
    home-manager.useGlobalPkgs = true;
    # nix (the package manager) configuration
    environment.systemPackages = [ pkgs.git ];
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true; # free software is for losers
    nixpkgs.overlays = outputs.overlays;
    nix.settings = {
        auto-optimise-store = true;
        substituters = [
          "https://cache.nixos.org"
          "https://accentor.cachix.org"
          "https://chvp.cachix.org"
          "https://lanzaboote.cachix.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "accentor.cachix.org-1:QP+oJwzmeq5Fsyp4Vk501UgUSbl5VIna/ard/XOePH8="
          "chvp.cachix.org-1:eIG26KkeA+R3tCpvmaayA9i3KVVL06G+qB5ci4dHBT4="
          "lanzaboote.cachix.org-1:Nt9//zGmqkg1k5iu+B3bkj3OmHKjSw9pvf3faffLLNk="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        trusted-users = [ "@wheel" ];
      };

    # (human) language and keyboard layout
    i18n.defaultLocale = "en_US.UTF-8";
    services.xserver.xkb = {
      layout = "us";
      variant = "colemak_dh"; # security by obscurity
    };
    console = {
      font = "Lat2-Terminus16";
      useXkbConfig = true; # does this cause problems on headless systems? i hope not!
    };

    users = {
# TODO: configure pw with age
#      mutableUsers = false;
      users.glitch = {
        isNormalUser = true;
        extraGroups = [ "wheel"];
      };
    };
  };
}
