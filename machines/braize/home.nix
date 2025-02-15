{ inputs, outputs, config, lib, pkgs, ... }: {
  glitch = {
    dotDir = "/Users/glitch/dts";
    isDarwin = true;
    graphical = {
#      enable = true;
      # old electron + DRM means it doesnt work on apple silicon
      spotify.enable = false;
      # DRM :(
      firefox.enable = false;

      fonts.enable = true;
    };
    development = {
      enable = true;
      emacs.enable = true;
    };
  };

  home.packages = with pkgs; [
    prismlauncher
    jetbrains.gateway
  ];
  programs.home-manager.enable = true;
  # makes home-manager update .profile so that applicatons show up in the DE
#  programs.bash.enable = true;
}
