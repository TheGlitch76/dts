{pkgs, ... }: pkgs.devshell.mkShell {
  name = "java lts";
  packages = with pkgs; [
    jdk
    jdt-language-server
  ];
  env = [{name = "JDTLS_PATH"; value = "${pkgs.jdt-language-server}";}];
}
