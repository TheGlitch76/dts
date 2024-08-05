{ config, lib, pkgs, ... } : {
  imports = [
    ./composition
    ./discord
  ];
  
  options.glitch.graphical.enable = lib.mkOption { default = false; };
  
  config = lib.mkIf config.glitch.graphical.enable {
    glitch = {
      graphical = {
        discord.enable = lib.mkDefault true;
        composition.enable = lib.mkDefault true;
      };
    };


    users.users.glitch.extraGroups = [ "input" "video" ]; # todo: is needed?
    
    environment.variables = { MOZ_ENABLE_WAYLAND = "0"; };
    home-manager.users.glitch = { ... }: {
      home.packages = with pkgs; [
        firefox
      ];
    };
  };
}
