{inputs, outputs, lib, pkgs, ... }: {
  imports = [
    ../common
  ];
  config = {
    system = {
#      configurationRevision = self.rev or self.dirtyRev or null;
      stateVersion = 4;
    };
    nixpkgs.hostPlatform = "aarch64-darwin";
    users.users.glitch.home = "/Users/glitch";
  };
}
