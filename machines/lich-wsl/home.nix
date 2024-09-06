{ inputs, outputs, config, lib, pkgs, ... }:

{
  glitch = {
    isDarwin = false;
    dotDir = "/home/glitch/dts";
    development = {
      emacs.enable = true;
      jetbrains.enable = true;
    };
  };
}
