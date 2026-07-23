{ lib, pkgs, inputs, ... }:


{
  imports = [
    inputs.walker.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    qbittorrent
    audacious
    alacritty
    obs-studio
    audacity
    gammastep
    discord
    vesktop
    obsidian
    spotify
    davinci-resolve
    paraview
    pavucontrol
    playerctl
    vlc
    rofi
    hledger
  ];

  programs.walker = {
    enable = true;
    runAsService = true;
  };
  systemd.user.services = {
    elephant.Install.WantedBy = lib.mkForce [ "sway-session.target" ];
    walker.Install.WantedBy = lib.mkForce [ "sway-session.target" ];
  };
  xdg.configFile."alacritty".source = ../config/alacritty;
  xdg.configFile."sway".source = ../config/sway;
  xdg.configFile."walker".source = ../config/walker;
  xdg.configFile."waybar".source = ../config/waybar;
  xdg.configFile."wlogout".source = ../config/wlogout;
}
