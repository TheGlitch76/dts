{ config, lib, pkgs, ... }:
{
  options.glitch.graphical.composition.enable = lib.mkEnableOption "composition";
  config = lib.mkIf config.glitch.graphical.composition.enable {
    home-manager.users.glitch = { ...}: { home.packages = with pkgs; [
      audacity
      musescore
      gimp

    ];
  }; };
}
