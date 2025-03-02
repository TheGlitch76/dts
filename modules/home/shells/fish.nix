{ config, lib, pkgs, ... }: {
  options.glitch.shells.fish.enable = lib.mkEnableOption "";
  config = lib.mkIf config.glitch.shells.fish.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # disable greeting

      '';
    };
  };
}
