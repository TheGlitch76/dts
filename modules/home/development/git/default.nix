{ config, lib, pkgs, ... }:

let
  gitIdentity = pkgs.writeShellScriptBin "git-identity" (builtins.readFile ./git-identity);
in {
  options.glitch.development.git.enable = lib.mkEnableOption {};
  config = lib.mkIf config.glitch.development.git.enable {
    home.packages = with pkgs; [
      gitIdentity
      fzf
    ];
    programs.git.aliases = rec {
      identity = "! git-identity";
      id = identity;
    };
  };
}
