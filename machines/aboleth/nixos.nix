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
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };
  system.activationScripts."tailscale-udp-gro-forwarding".text = ''
    ${pkgs.ethtool}/bin/ethtool -K enp1s0 rx-udp-gro-forwarding on rx-gro-list off
  '';

  age.secrets."keys/curseforge".file = ../../secrets/keys/curseforge.age;

  users.users.minecraft = {
    isSystemUser = true;
    home = "/srv/minecraft";
    uid = 25565;
    group = "minecraft";
  };
  users.groups.minecraft.gid = 25565;
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
    };
    oci-containers.containers = {
      moni = {
	environment = {
	  EULA = "true";
	  MOD_PLATFORM = "AUTO_CURSEFORGE";
	  CF_SLUG = "monifactory";
	  CF_FILE_ID = "6741501";
	  MEMORY = "6G";
	  JVM_XX_OPTS = "+UseShenandoahGC";
	  UID = "25565";
	  GID = "25565";
	};
	environmentFiles = [ config.age.secrets."keys/curseforge".path ];
	image = "itzg/minecraft-server:java23";
	ports = ["0.0.0.0:25565:25565/udp"];
	volumes = [ "/srv/minecraft/moni/:/data" ];
      };
    };
  };
  systemd.tmpfiles.rules = [ "d /srv/minecraft/moni 0775 root root -"];
}
