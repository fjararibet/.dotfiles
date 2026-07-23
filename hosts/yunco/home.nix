{ pkgs, ... }:

{
  imports = [ ../../home/common.nix ];
  home.packages = with pkgs; [
    google-cloud-sdk
  ];
}
