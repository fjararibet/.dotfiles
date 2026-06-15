{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems.zfs = true;
  boot.zfs.extraPools = [ "zpool" ];

  networking.hostName = "pudu";
  networking.hostId = "41c929f8";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Santiago";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CL.UTF-8";
    LC_IDENTIFICATION = "es_CL.UTF-8";
    LC_MEASUREMENT = "es_CL.UTF-8";
    LC_MONETARY = "es_CL.UTF-8";
    LC_NAME = "es_CL.UTF-8";
    LC_NUMERIC = "es_CL.UTF-8";
    LC_PAPER = "es_CL.UTF-8";
    LC_TELEPHONE = "es_CL.UTF-8";
    LC_TIME = "es_CL.UTF-8";
  };

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  # Tailscale from the wiki
  services.tailscale.enable = true;
  networking.nftables.enable = true;
  systemd.services.tailscaled.serviceConfig.Environment = [ 
    "TS_DEBUG_FIREWALL_MODE=nftables" 
  ];
  systemd.network.wait-online.enable = false; 
  boot.initrd.systemd.network.wait-online.enable = false;

  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };
  
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "juanghurtado";
    };
  };
  programs.ssh.startAgent = true;
  users.users.fjara = {
    isNormalUser = true;
    description = "Felipe Jara";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [ 
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOcuwvBPI2wqAAEEb0wATdzbXvO8rYQdtBarPIHPlNSq fjararibet@gmail.com"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [ 
      neovim
      ripgrep
      nodejs_24
      gcc
      tmux
      atuin
      git
    ];
  };

  environment.systemPackages = with pkgs; [
   vim
   wget
   curl
  ];


  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
  };


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
