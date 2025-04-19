{ inputs, outputs, config, lib, pkgs, ... }: {
  imports = [
    ./development
    ./graphical
    ./shells
  ];

  options.glitch.dotDir = lib.mkOption {};
  options.glitch.isDarwin = lib.mkOption {};
  config = {
    programs.bash.enable = true; # need .profile to be updated for home.sessionVariables
    xdg.enable = true;
  };
}
