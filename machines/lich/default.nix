
#
# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, outputs, config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
    ];
  boot.supportedFilesystems = [ "ntfs" ];
#  glitch.dotDir = "/home/glitch/dot2";
   networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  madness.enable = true;
  # Set your time zone.
  time.timeZone = "America/Chicago";
  services.displayManager.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  programs.dconf.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  environment.systemPackages = with pkgs; [
    # for sanity for now
    openshot-qt
    spotify
  ];

  home-manager.users.glitch = { ... }: {
    glitch = {
      development = {
        emacs.enable = true;
        jetbrains.enable = true;
      };
      graphical.enable = true;
      dotDir = "/home/glitch/dot2";
    };
    home.packages = with pkgs; [
      firefox # TODO: come up with a better solution
    ];
  };
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  security.rtkit.enable = true;
   services.pipewire = {
     enable = true;
     pulse.enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
   };

  # not worth the effort for my development machines
  networking.firewall.enable = false; 
}

