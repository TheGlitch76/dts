{ inputs, outputs, config, lib, pkgs, ... }: {
  imports = [
    #./zsh
    ./fish.nix
  ];
  config = {

    programs.zsh.enable = true;
    glitch = {
      shells.fish.enable = lib.mkDefault true;
    };
  };
}
