{ inputs, outputs, config, lib, pkgs, ... }: {
  imports = [
    ./development
    ./graphical
    ./zsh
  ];

  options.glitch.dotDir = lib.mkOption {};

  config = {
    nixpkgs.config.allowUnfree = true;
  };
#  nixpkgs.config.allowUnsupportedSystem = true;
}
