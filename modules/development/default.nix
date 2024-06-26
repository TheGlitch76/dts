{ config, lib, pkgs, ... } : {
  imports = [
    ./jetbrains
    ./neovim
  ];

  options.glitch.development.enable = lib.mkEnableOption "development settings";
}
