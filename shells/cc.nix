# to the surprise of nobody, c-family compiliation on darwin is EXTREMELY scuffed.
# as of 5 mar 2025, clangd is somehow managing to find the gcc implementation of the cstd...
# It seems to be related to nix/nixpkgs#191152 but not exactly because it only affects
# clangd outside of the stdenv.
# So we're going to just use the shitty nix shell with stdenv instead.
{ pkgs, lib, inputs, ... }: pkgs.llvmPackages_19.stdenv.mkDerivation {
  name = "cc";
  nativeBuildInputs = with pkgs; [
    clang-tools
    lldb
    valgrind
  ];
}
