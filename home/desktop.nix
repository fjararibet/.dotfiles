{ config, lib, pkgs, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.hostPlatform.system; config.allowUnfree = true; };
in

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
    htop
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
