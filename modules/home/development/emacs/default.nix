{ lib, config, pkgs, ... }:
let
  emacs-pkg = with pkgs; (emacsPackagesFor (emacs29-pgtk)).emacsWithPackages (epkgs: with epkgs; [ vterm ]);
  thisDir = "${config.glitch.dotDir}/modules/home/development/emacs";
in {
  options.glitch.development.emacs.enable = lib.mkEnableOption "emacs";
  config = lib.mkIf config.glitch.development.emacs.enable {
    home.packages = with pkgs; [
      binutils
      emacs-pkg
      # doom deps
      git
      ripgrep
      gnutls
      fd
      imagemagick
      zstd
      # tools
      direnv
      # sh
      shellcheck
      bash-language-server
      shfmt
      # nix
      nil
      nixfmt-rfc-style
      # rust
      rustup
      # javascript (ew!)
      nodejs
      yarn
      typescript
      typescript-language-server
    ];
  #  home.file.".doom.d" = lib.mkIf config.glitch.isDarwin {
 #     source = config.lib.file.mkOutOfStoreSymlink "${thisDir}/doom";
#    };
    xdg.configFile = {
      "doom".source = config.lib.file.mkOutOfStoreSymlink "${thisDir}/doom/";
    };
  };
}
