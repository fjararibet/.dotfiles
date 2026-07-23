{ config, lib, pkgs, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.hostPlatform.system; config.allowUnfree = true; };
in

{
  imports = [
    ../../home/common.nix
    ../../home/desktop.nix
  ];

  home.packages = [
    pkgs.zapzap
    unstable.osu-lazer-bin
  ];
}
