# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, nixpkgs-unstable, ... }:
let
  unstable = import nixpkgs-unstable { system = pkgs.system; config.allowUnfree = true; };
in
{
  nix.settings.auto-optimise-store = true;
  services.tailscale = {
	  enable = true;
  };
  services.resolved = {
	  enable = true;
	  settings.Resolve.DNSSEC = "false";
	  settings.Resolve.Domains = [ "Dimacofi.cl" ];
  };
  services.openssh.enable = true;
  systemd.services.tailscaled.after = [ "systemd-resolved.service" ];
  systemd.services.tailscaled.wants = [ "systemd-resolved.service" ];

# Upstream = WSL's DNS proxy (which proxies to Windows / corporate DNS)
  networking.hostName = "yunco";
  networking.nameservers = [ "10.255.255.254" ];
  networking.firewall.enable = false;

  # fixes opencode/claude freezes
  services.timesyncd.enable = false;
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
  ];
  programs.direnv = {
	  package = pkgs.direnv;
	  silent = false;
	  loadInNixShell = true;
	  direnvrcExtra = "";
	  nix-direnv = {
		  enable = true;
		  package = pkgs.nix-direnv;
	  };
  };
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "refined";
      # theme = "robbyrussell";
    };
  };
  programs.atuin = {
    enable = true;
    daemon.enable = true;
    flags = [
      "--disable-up-arrow"
    ];
    settings = {
    	daemon.enabled = true;
	daemon.autostart = true;
	search_mode = "daemon-fuzzy";
	enter_accept = true;
    };
  };
  i18n.extraLocales = ["es_CL.UTF-8/UTF-8"];
  virtualisation.docker = {
    enable = true;
  };
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "oracle-instantclient"
      "ngrok"
    ];
  users.users.fjara = {
      isNormalUser = true;
      uid = 1002;
      extraGroups = [ "wheel" "docker" ];
      shell = pkgs.zsh;
      packages = with pkgs; [
        wl-clipboard
        neovim
	uv
	oracle-instantclient
        nodejs_22
        (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.cloud-firestore-emulator ])
        git
        stow
	fd
	ripgrep
	dotenv-cli
	tree-sitter
	postgresql
	tmux
	terraform
	jq
	openjdk21
	clang
	unstable.claude-code
	unstable.wrangler
	nix-direnv
	rclone
      ];
  };
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
  ];

  wsl.enable = true;
  wsl.defaultUser = "fjara";
  wsl.wslConf.network.generateResolvConf = false;
  wsl.wslConf.network.hostname = "yunco";


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
