{ config, lib, pkgs, ... } : {
  imports = [
    ./jetbrains
    ./emacs
#    ./neovim
  ];

  options.glitch.development.enable = lib.mkEnableOption "development settings";
  config = lib.mkIf config.glitch.development.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    home.file.".editorconfig".source = config.lib.file.mkOutOfStoreSymlink "${config.glitch.dotDir}/modules/home/development/editorconfig";
  };
}
