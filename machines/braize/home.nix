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
        package = pkgs.emacs-git;
      };
    };
  };

  home.packages = with pkgs; [
    # https://github.com/NixOS/nixpkgs/pull/400306
    #prismlauncher # is rebuilding qtdeclarative for no reason
    jetbrains.gateway
  ];
}
