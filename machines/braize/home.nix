{ inputs, outputs, config, lib, pkgs, ... }: {
  glitch = {
    dotDir = "/Users/glitch/dts";
    isDarwin = true;
    graphical = {
      fonts.enable = true;
    };
    development = {
      enable = true;
      emacs = {
        enable = true;
        package = pkgs.emacs;
      };
    };
  };

  home.packages = with pkgs; [
    prismlauncher
    jetbrains.gateway
  ];
}
