{ inputs, outputs, config, lib, pkgs, ... }: {
  imports = [
    #./zsh
    ./fish.nix
  ];
  config = {
    glitch = {
      shells.fish.enable = lib.mkDefault true;
    };
  };
}
