# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "btrfs" ];
  systemd.network.networks."10-wan" = {
    matchConfig.name = "enp1s0";
    networkConfig.DHCP = "ipv4";
    linkconfig.RequiredForOnline = "routable";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.glitch = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF9F3+irAVmMXm399GgX4eRx4bP8lLjeZTIkkz3quRCJ shadesmar"
"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMOdxQIC+Qn09O9P7pC52odvTCDoXeV5XDdAO6PJrAaa"];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.ports = [ 2269 ];
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

}
