{ inputs, outputs, config, lib, pkgs, ... }: {
  glitch = {
    dotDir = "/home/glitch/dts";
    graphical = {
      enable = true;
      # old electron + DRM means it doesnt work on apple silicon
      spotify.enable = false;
      # DRM :(
      firefox.enable = false;
    };
    development = {
      emacs.enable = true;
    };
  };

  programs.home-manager.enable = true;
}
