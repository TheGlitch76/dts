{ config, lib, pkgs, ... }: {
  options.glitch.shells.fish.enable = lib.mkEnableOption "";
  config = lib.mkIf config.glitch.shells.fish.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # disable greeting
      '';
      shellAbbrs = {
        nos = "sudo nixos-rebuild switch --flake ${config.glitch.dotDir}";
	abde = "nixos-rebuild switch --flake ${config.glitch.dotDir}#aboleth --target-host aboleth --sudo --ask-sudo-password";
        nds = "darwin-rebuild switch --flake ${config.glitch.dotDir}";
        nfu = "nix flake update";
      };
    };
  };
}
