{ inputs, outputs, config, lib, pkgs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../common
#    ./zsh
  ];
  options.glitch = {};
  config = {
    # (human) language and keyboard layout
    i18n.defaultLocale = "en_US.UTF-8";
    services.xserver.xkb = {
      layout = "us";
      variant = "colemak_dh"; # security by obscurity
    };
    console = {
      font = "Lat2-Terminus16";
      useXkbConfig = true; # does this cause problems on headless systems? i hope not!
    };

    users = {
# TODO: configure pw with age
#      mutableUsers = false;
      users.glitch = {
        isNormalUser = true;
        extraGroups = [ "wheel"];
      };
    };
  };
}
