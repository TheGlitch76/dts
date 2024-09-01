{ pkgs, inputs, outputs, lib, ... }:

{
  home-manager.users.glitch = import ./home.nix;

}
