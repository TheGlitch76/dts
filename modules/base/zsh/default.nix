{ config, lib, pkgs, ... }:

let base= ({
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true; #what is this?
    
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-cfg";
        src = ./p10k;
        file = "p10k.zsh";
      }
    ];
  };
});
in
{
  home-manager.users.glitch = { ... }: (base);
  home-manager.users.root = { ... }: (base);
  users.defaultUserShell = pkgs.zsh;
  environment.shells = [ pkgs.zsh ];
  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh.enable = true;  
}
