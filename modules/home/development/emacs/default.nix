{
  lib,
  config,
  pkgs,
  ...
}:
let
  emacs-pkgs = with pkgs; [
  ];
  generate-emacs-pkg = emacs:
    (pkgs.emacsPackagesFor emacs).emacsWithPackages (
      epkgs:
      with epkgs;
      [
        vterm
        treesit-grammars.with-all-grammars
      ]
    );
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
      dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of fontspec etoolbox;
  });
  thisDir = "${config.glitch.dotDir}/modules/home/development/emacs";
in
{
  options.glitch.development.emacs = {
    enable = lib.mkEnableOption "emacs";
    package = lib.mkOption {};
  };
  config = lib.mkIf config.glitch.development.emacs.enable {
    # this holds things that:
    # - cant be wrapped into the emacs pkg because they're called thru a shell
    #   (or something similar),
    # - are too common to be used in a devshell
    # - i am too lazy to put in a devshell
    home.packages = with pkgs; [
      (generate-emacs-pkg config.glitch.development.emacs.package)
    ];

    xdg.configFile = {
      "emacs".source = config.lib.file.mkOutOfStoreSymlink "${thisDir}/config/";
    };
    home.sessionPath = [ "${config.xdg.configHome}/emacs/bin/" ];
    home.sessionVariables = {
      DOTFILES_DIR = config.glitch.dotDir;
    };
  };
}
