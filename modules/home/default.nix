{ inputs, outputs, config, lib, pkgs, ... }: {
  imports = [
    ./development
    ./graphical
    ./zsh
  ];

  options.glitch.dotDir = lib.mkOption {};
  options.glitch.isDarwin = lib.mkOption {};
  config = {
    nixpkgs.config.allowUnfree = true;
    xdg.enable = true;
  };
#  nixpkgs.config.allowUnsupportedSystem = true;
}
