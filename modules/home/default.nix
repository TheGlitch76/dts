{ inputs, outputs, config, lib, pkgs, ... }: {
  imports = [
    ./development
    ./graphical
    ./shells
  ];

  options.glitch.dotDir = lib.mkOption {};
  options.glitch.isDarwin = lib.mkOption {};
  config = {
    xdg.enable = true;
  };
}
