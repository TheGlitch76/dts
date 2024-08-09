{ lib, config, pkgs, ... }:
let
  emacs = with pkgs; (emacsPackagesFor emacs-pgtk).emacsWithPackages (epkgs: with epkgs; [ vterm ]);
  thisDir = "${config.glitch.dotDir}/modules/home/development/emacs";
in {
  options.glitch.development.emacs.enable = lib.mkEnableOption "emacs";
  config = lib.mkIf config.glitch.development.emacs.enable {
    home.packages = with pkgs; [
      binutils
      emacs
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
      bashdb
      shfmt
      # nix
      nil
      nixfmt-rfc-style
      # rust
      rustup
    ];
    xdg.configFile = {
      "doom".source = config.lib.file.mkOutOfStoreSymlink "${thisDir}/doom";
    };
  };
}
