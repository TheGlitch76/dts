{ config, lib, pkgs, ... } : {
  imports = [
    ./jetbrains
    ./emacs
#    ./neovim
  ];

  options.glitch.development.enable = lib.mkEnableOption "development settings";
}
