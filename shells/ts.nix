{ lib, pkgs, ... }: pkgs.devshell.mkShell {
  name = "basic typescript";
  packages = with pkgs; [
    nodejs
    yarn
    typescript
    typescript-language-server
  ];
}
