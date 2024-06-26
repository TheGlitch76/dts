{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  environment.systemPackages = with pkgs; [
    pkgs.sbctl # for secure boot
    # for graphical stuff
  ];
  environment.variables = { MESA_LOADER_DRIVER_OVERRIDE = "zink"; };

  hardware = {   
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
      ];
    };
  };


  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader.efi.canTouchEfiVariables = true;
    loader.timeout = 0;
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    kernelParams = [ "nvidia_drm.fbdev=1" ];
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/7e68185f-234a-4b6e-bec7-d2115d100ff9";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/7e68185f-234a-4b6e-bec7-d2115d100ff9";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/7e68185f-234a-4b6e-bec7-d2115d100ff9";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd noatime"];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/59F9-16F6";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp24s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
