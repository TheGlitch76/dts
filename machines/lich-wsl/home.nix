{ inputs, outputs, config, lib, pkgs, ... }:

{
  glitch = {
    isDarwin = false;
    dotDir = "/home/glitch/dts";
    development = {
      enable = true;
      emacs = {
        enable = true;
        package = pkgs.emacs-git-nox;
      };
      jetbrains.enable = true;
    };
    graphical = {
      fonts.enable = true;
    };
  };
  home.sessionVariables = {
    COLORTERM = "truecolor"; # for emacs
  };
}
