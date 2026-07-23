{ pkgs, paths, ... }:

{
  imports = [ (paths.home + "/common.nix") ];
  home.packages = with pkgs; [
    google-cloud-sdk
  ];
}
