{ config, pkgs, ... }:

{
  home.username = "fjara";
  home.homeDirectory = "/home/fjara";
  programs.home-manager.enable = true;
  home.stateVersion = "26.05";

  xdg.configFile."alacritty".source = ./config/alacritty;
  xdg.configFile."atuin" = { source = ./config/atuin; recursive = true; };
  xdg.configFile."clangd".source = ./config/clangd;
  xdg.configFile."git".source = ./config/git;
  xdg.configFile."sway".source = ./config/sway;
  xdg.configFile."tmux".source = ./config/tmux;
  xdg.configFile."walker".source = ./config/walker;
  xdg.configFile."waybar".source = ./config/waybar;
  xdg.configFile."wlogout".source = ./config/wlogout;
  xdg.configFile."nvim".source = ./config/nvim;
  home.file.".zshrc".source = ./config/zsh/dot-zshrc;

}
