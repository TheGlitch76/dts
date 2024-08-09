# on asahi we want to use the fedora-provided one for widevine
{ config, lib, pkgs, ... }: {
  options.glitch.graphical.firefox.enable = lib.mkEnableOption "firefox";
  config = lib.mkIf config.glitch.graphical.firefox.enable {
    home.packages = [ pkgs.firefox ];
  };
}
