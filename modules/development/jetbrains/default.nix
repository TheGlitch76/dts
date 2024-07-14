# https://gist.github.com/Lgmrszd/98fb7054e63a7199f9510ba20a39bc67
{ config, lib, pkgs, ... }:

{
  options.glitch.development.jetbrains.enable = lib.mkOption {
    default = false;
  };
  config = lib.mkIf config.glitch.development.jetbrains.enable {
    home-manager.users.glitch = 
    { ... }: let
#      hjdk = name: ".jdks/${name}".source = pkgs.${name};
    in {
      home.packages = with pkgs; [ (symlinkJoin {
        name = "idea-ultimate";
        paths = [ jetbrains.idea-ultimate ];
        buildInputs = [ makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/idea-ultimate \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [libpulseaudio libGL glfw openal stdenv.cc.cc.lib udev gamemode.lib libusb1]}"
        '';
      }) ];
     
      home.file.".jdks/openjdk8".source = "${pkgs.jdk8}/lib/openjdk";
      home.file.".jdks/openjdk17".source = pkgs.jdk17;
    };
    programs.java.enable = true;
  };
}
