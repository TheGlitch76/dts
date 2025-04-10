{
  lib,
  config,
  pkgs,
  ...
}:
let
  emacs-pkgs = with pkgs; [
    binutils
    ripgrep
    gnutls
    imagemagick
    python3
    (aspellWithDicts (
      d: with d; [
        en
        en-computers
        en-science
      ]
    ))
  ];
  emacs-pkg =
    with pkgs;
    (emacsPackagesFor (pkgs.emacs-git-pgtk)).emacsWithPackages (
      epkgs:
      with epkgs;
      [
        vterm
      ]
      ++ emacs-pkgs
    );
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
      dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of fontspec etoolbox;
  });
  thisDir = "${config.glitch.dotDir}/modules/home/development/emacs";
in
{
  options.glitch.development.emacs.enable = lib.mkEnableOption "emacs";
  config = lib.mkIf config.glitch.development.emacs.enable {
    # this holds things that:
    # - cant be wrapped into the emacs pkg because they're called thru a shell
    #   (or something similar),
    # - are too common to be used in a devshell
    # - i am too lazy to put in a devshell
    home.packages = with pkgs; [
      emacs-pkg
      # for some reason doom shits the bed if this is wrapped
      zstd
      fd
      tex
      # tools
      direnv
      jj
      # sh
      shellcheck
      bash-language-server
      shfmt
      # nix
      nil
      nixfmt-rfc-style
      # rust
      rustup
    ];

    xdg.configFile = {
      "doom".source = config.lib.file.mkOutOfStoreSymlink "${thisDir}/doom/";
    };
    home.sessionPath = [ "${config.xdg.configHome}/emacs/bin/" ];
  };
}
