{ inputs, outputs, config, lib, pkgs, ... }:

{
  glitch = {
    isDarwin = false;
    dotDir = "/home/glitch/dts";
    development = {
      enable = true;
      emacs.enable = true;
      jetbrains.enable = true;
    };
  };
}
