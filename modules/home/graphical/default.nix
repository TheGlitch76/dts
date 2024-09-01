{ config, lib, pkgs, ... } : {
  imports = [
    ./firefox
    ./fonts
    ./spotify
  ];
  
  options.glitch.graphical.enable = lib.mkOption { default = false; };
  
  config = lib.mkIf config.glitch.graphical.enable {
    glitch = {
      graphical = {
        spotify.enable = lib.mkDefault true;
        fonts.enable = lib.mkDefault true;
      };
    };
    home.packages = with pkgs; [
      armcord # gets around krisp not working
      # grahpical utils i use a lot
      audacity
      musescore
      gimp
    ];
  };
}
