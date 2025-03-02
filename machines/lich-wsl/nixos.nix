{ inputs, outputs, config, lib, pkgs, ... }:

{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  wsl = {
    enable = true;
    defaultUser = "glitch";
    wslConf = {
      network.hostname = "lich-wsl";
    };
  };
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
