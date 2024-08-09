# spotify has to be run thru the browser on asahi, so an opt-out is needed
{ config, lib, pkgs, ... }: {
  options.glitch.graphical.spotify.enable = lib.mkEnableOption "spotify";
  config = lib.mkIf config.glitch.graphical.spotify.enable {
    home.packages = [ pkgs.spotify ];
  };
}
