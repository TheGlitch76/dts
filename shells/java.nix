{ config, lib, pkgs, ... }: pkgs.devshell.mkShell {
  name = "java lts";
  packages = with pkgs; [
    jdk
  ];
}
