{ pkgs, ... }:

{
  imports = [
    ../../home/common.nix
    ../../home/desktop.nix
  ];

  home.packages = with pkgs; [
    zapzap
    unstable.osu-lazer-bin
  ];
}
