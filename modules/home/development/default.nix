{ config, lib, pkgs, ... } : {
  imports = [
    ./jetbrains
    ./emacs
    ./git
#    ./neovim
  ];

  options.glitch.development.enable = lib.mkEnableOption "development settings";
  config = lib.mkIf config.glitch.development.enable {
    glitch.development.git.enable = lib.mkDefault true;
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    home.file.".editorconfig".source = config.lib.file.mkOutOfStoreSymlink "${config.glitch.dotDir}/modules/home/development/editorconfig";
  };
}
