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
    unstable.osu-lazer-bin
  ];
}
