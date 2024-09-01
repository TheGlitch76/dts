{ config, lib, pkgs, ... } : {
  options.glitch.graphical.fonts.enable = lib.mkEnableOption "fonts";
  
  config = lib.mkIf config.glitch.graphical.fonts.enable {
    home.packages = with pkgs; [
      (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; })
    ];
    fonts.fontconfig.enable = true;
  };
}
